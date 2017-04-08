class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	helper_method :pdf_icon, :current_user, :generate_checks_and_form_attrs, :white_list_attrs
	require 'osc_ruby'

	def rn_test_client

		rn_client = OSCRuby::Client.new do |config|
		    config.username = ENV['OSC_ADMIN']
		    config.password = ENV['OSC_PASSWORD']
		    config.interface = ENV['OSC_TEST_SITE']
		end

	end

	def pdf_icon_source
		'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIAAAACACAYAAADDPmHLAAAgAElEQVR4Xu19CXhTxfr+e5KmSUt3Cm2llH0TFxC8CiKLIsqmoCgCWgVUFLyICAiCei/KooLo9Sqof9e/K1fZQXYQEIKgiFB2VKhAV6AtdMl2fs87zQmnadIkBZK0dJ4nT9OcOdt877zfMt/MSPCuSAA0O3fuvLe4uPg/BoMhUafTeXdmNatVVFQEi8WClJQUmEymzdu3bx8+ZMiQowBsVfFVKVhPhXVCli9ffn/79u2/jImJgVar9XROtT5uNpuRlZUFSZJgs9ny161bd9fw4cN/toNArkov7w0AKO1ahw4d2tegQYN6V7rwFeFarVakp6eLf2VZzl+2bFmvZ5991ljVQOANAAwA6mRmZh6vXbt2VQL3ZX/WwsJCnD17VjBBYWFh/ooVK6ocCLwBQCSAlJycnL2k/yu1yPIFZrfZStW9yWTCX3/9hYYNG4q/oaGhVQ4E3gCAUm+Sk5Oz80oCgCJwRdj8q/5up36cOXMGBoMBxcXFgg0IgpUrV1YZJvAGAHEAmmVmZhqvJBWgBoCz4Pm/cjwvLw8lJSVISkrC7t27ERYWBp1Ol79mzZoqAYIaALjRaRSwp97P43QLT58+jRYtWmDPnj3i/9DQUMEE69atC3oQ1ACgEgBQg6OgoECogauvvhonTpwQYKhKIPAaABkZGcb4+PgrwgZ0R/8KI6gBkJ+fj9zcXFx77bXIyckRdgABwA+DZXq9Pv+TTz7pOGfOnAMArMHWgDUAcCERZwCoVYGzaiADMCjUtm1bEAznzp2jS1gGBBaLZd/kyZN7rF+/PiPYQOA1AE6dOmWsU6dOsAH4sjxPRfrf+RgpnwzQrl07IXQKn0ahGgQMnlmt1n2zZs3qvmDBgsxgChvXAMANAzgbgGrLX3EJ+Zf6Pzs7G//4xz8oZCF8AoFuoaIK+Fej0fB42tSpU+9YtWpV0ICgBgAVAMAZBK6YgQyQmZmJDh06iCt5AoHJZEqbNm1a0IDAawCkp6cb6etW2cJIXv5ZwGYBJA0QGQO4GdRSBO0c/HEFABp+p06dwq233upomopAwEoWiyVoQHBFAEA+/gds65fCtuRr4MxpIDwCIf0GAUNGQgqvVQ7TngCgBgYB8Pfff6Nr165lruMJBCUlJWkzZ84MOBNUbwCYTbAu/gK2Oa9AzqTavVA0AAqGDEfohJnCXWPwRim+AID0TwDcfvvt5YBUEQgIIqqD1157LaAg8BoAx48fN1511VVVRwNYzLDOnQ7r26+5fGa+eJFOh1Nzv4OhUXPQwwkPDxd1nQHg7P8rDEAB0wXksHCPHj1c3scdCM6fPy/uQyZ44403AgaCagsAeecmmFP7AiazW9DqQrQ4mjoSIYOfEkO6ycnJItnFFwCQAf7880/07t3b7X1cgYDxAnoKzC4iE8yePTsgIPAaAMeOHTPWq1evajBASREszz8G27KFF2g9JAQSh3HtQ7k8EKqRsK9DN8TM+ADskQkJCYiKivIZAEePHkXfvn0rbBtnEBAAirtIEBQXF6fNmTPH7yCongDIyYCpayuguEQIhS9Z2LgJtPl50OfkQBnZ10vAnsT6SFiwRYRxGeqmKvCFATIyMnDw4EHce++9HjtHRSBgmllRUVHa22+/7VcQVEsAyNvWwfzwhR7JnLYzN3VESOF51NqzuwwAdkXXRqN1e8VATmxsrBjWVQPA7ra5tA0oUAJg//79GDBggEcAuIoTqJnAHkRKe+edd/wGAq8BcOTIESMzX6pCsS78HNbxTzoeVTBAo8aQ4+IRtvc3SCUmcYzAOBcTg6w5X0FKShZj+Yqhq472sa4SCVT/TgCcPHlSAOCBBx7wumkqYgKCoKCgIG3u3Ll+AUH1BMCCT2GdMLIMACwRETh36+3Q79yKsOxswQJ0BW3RMTj+2ofQNrlahGvJAHQLFcuf+lnpuQoQ1F4APYC0tDQMGTLEawB4YgIah+fOnfMLCKonAJwYQPR2CThzSxfoDh9AeGamAwDW6Bikz/wQ2qZXC0+AAGBMwDkK6I4BCIC9e/fioYce8gkA3oAgPz8/7f3337+sTOA1AA4fPmxs1KiRzy8ZiBPkTT/APOy+Mrfmi5YkJUGblwdtYaE4RgYQAJj1CbQNmzsAoNfrXRqC6lAwmYFUfvz4cZEJlJqaWqlXrUgd0DM5f/78ZQVBtQQAsk7A1KklYHPKv9DpIFutpe4gAJ0EZMbWhuXLdSiUIXo+GaAiAKiNQrICYwC//vorhg8fXikAeGIC5hsUFhamffDBB5eFCbwGwKFDh4yNGzeu9Ev69cQz2TDf1wny8dKJG+4K3UB6AQ3W/C4ieszuVVSAOilEsQNcqQEagWvXrsXo0aMv6hUrYgKCgIYhvYPNmzdf0qHk6gmAwvOwjEuFbfUPHgGwJyEZCQt/EnEABoESExMdU99cxQOcXUSCYu7cuWIsgDkBF1MqAgGzjWgTvPvuu5cUBNUTAFYrrPM/gvXFMRXKI1QC9l3TDnFz/ycSOwgAuoE0Blmch38VJnAGBmMI8+fPR1xcnHAl6U3wGvzL0DK/Kx96GOr/+T2EUUpVHfVD83eqJKonRg7z8vLS3nvvvUsGAq8BcODAAWPTpk0vBuB+PVc+sg/mgbcBeflu76vTaHCgWy9Ev/wWGxac+OKc8+COBXhR55gA7QHld1c3ZX2CwlNR1+E5TC8jQxEE9mloafPmzbskIKi2AMC5PFjGpsK2fo3b9taGaHFk4DDUeny8SOhkKLhu3brl6hMEajvAnUuosIZSX7EjlL8M96rrKDdSYg4VAYPZxrQ3eA2C4NixY2+OHz9+Mp0bkpUnULk7Xn0BIMuw/u8jWF9wb5xpdDr88c8pCO11v8jlIwBczX7yZWzAGQTOAleDQDnmLBw1INRsQJYiCOy5hieHDh16PYA8AO6HPD0gw2sApKWlGTn7RSlsFEVXVhZ9l/s8+dAeWB6/D/KJv8vdii8uG/Q4PvVdaNrcLHx6DgS5mv9YGQAowiVzqJlAAYCz8JU6FbUJ25v2BsHKXMRBgwY1AXCKqQ2VbctqDQCYTbD8ezRs33xern2oibMM4ShZ8jNMZrPQrxwOVpJCnE/wxRZw7vVq41EteHdgcEvXkkR3EJGRkSIJpVu3bmSAvwC4N3QuFQPs2bPH2KpVqyrFAKKxNy6HedQQwD4ApLwAAZBRNwGWrzaIHkUA0AOgxe2uVOQW8hx1+JiM4mwDOLOBch81EDz1ZBqEHLUkE9x88803AuDyNGc8nXfRNkBVBQDyzsAycThsa1aWaQMC4MS1baF951uRDEL3rX79+h7VmrcgIADUvV0Bg8IGro55EiJVACehNGnSBPv27SMAbgZwGMBpT+deuQBgvH/Jl7A+PxKwW+FsDOq+M3HxyP1gMTRh4YiIiIC3GU/eqgPeRw0EtZ53BQRvhMiIZfPmzcUAVMeOHf0HgN9//93IGbBKqQpGoONhs07APGYI5J+5jtOFotdo8MfDI2B4bJwQFAHgrWHryTB0pRIq6vVqQFQEBOYgKlPRawDgTZex17E8Mxi25YvKnMHBoBMNGsM2byEsGq0wAmvVKj9PwNVt1GMFniaQKGBwZgR1Z/LmVaiqaANQBezatQudOnWqYQBvGg65WTA/dR/kX38pU51qQK/T4rfhzyExdaRgAV9mP3kCgVrw6mlmaiD4AgJ6AFyXiJlZfgfA7t27ja1bty5j2Ahdao+beyWIAFWS9/4CyzMPQT52rNwThGqAkw2bwfbf+bDqDWIwqCJPwPkCFYFAoXxn4auBoVxPsRUqaiKOVzAwRGN1586dnI7mPwbYtWuXkYsgqF/Km7h2gGRe5ra2ld/DOmEEUOQ6XmLQ67D14dFoMny0YAGqgsoUV1lEar2vjvA5h389hYPpKjKBlO4qw9Xbt2/ndLQaAHgjKOt702CbM91tVbJAVvNWOD/jI2iiYkVEkG5hZYpzb3f+X+0J+AICxipI/+x0BMC2bdtqAOCtgKyMA3z/TYXVDTotlvd+CDdOfEUM/BAEF8NwnoDgSvdXxAKM/7PwmTjsvGXLFkYC/ccAO3fuNLZp06bqqYDMk7A89zDk7VzF1X1h0qitUWPsf/5NxLe6BtHR0W7Dwt4CT63rL4b+lUQRXo/5BAwF1wDASynYft0C69NDgOwcxxmW6GjoCgshqwJDPGjQSFjW71G0HTOZ1q2g2othAedHrCwI1KFiJphQPf3444/MQqphAE84sC3/BtaxjzvmBHIySHa/B2HIy0X4hrK5AgwPhybWwdYxM9Hglq4iQ8jd4JCn+3pz3JPhpzCIOkjE7CGygN8BsGPHDiNXwmJRuyyXsod402g+1bHZYH3rZdjmvuk4jYmg+8a9Am3L65H89ECEOHkGeo2EtO73IHTMvxAeESE8gkC+o3OEUEkf27hxI7p37+4/BnAGgJLeFMjG8QiG0zmwTHgU8o8bHFVp7G157TOk3PAPhM58DnErl5bZ6UEEhyIM2Pbca0jq3AMxsbFC5waqBA0Atm/fbuRSaAoDVAUA2Pb/BuvQu4HcXPHcFG5oSjK2/etDJKY0QP6fh9FswiMIOXO2TE4VQ8RFN7TDn1PeQ0xcnGCBQOyToI4rKABUGGDdunW48847/ccAVRIA65fBOmKgo/Nyk5vC7j3x54jJMERGIUSrRf3V38L6xtRyHZwG4Y7hzyGy/xDExdV2mSp2uVnB1QBRDQC8bXWrBSIA9J/XL9C/RsIvIyYh9t7BKDGZER0ViYQQCZZhfSDv31/mykIVxEbj9//MR63EZJEsol5HyNvHqGw9V72f11IAsGbNGvTs2dN/DGA0Go3t27evOiogJwOWpx+A/EvpAJAQqEGH1VPeQ8tOXUQSSO24ONSOj4dt6Zewjn2inKwYG/j7lttQOOF1REZFeZ0vUFmhK+e5E34NAHxoWdvhNFj7d3KkgtHF0zVtAuP4N5HQpJlIA+Ogigj5ni+AdfII2JYvLncHMXdg3KvQ3dZHZA0zQHS5S0W5AQoDrF69Gr169aphAHfCsH3/CawTn75A/xKQ3nsAip6YyFmgIl+Pcx0VL8a2/UdYRw0C8phlfaGIxSXi4nDynfkIT6wnRgsvpyqoqPerGcDvANi6datRmfvGOEBQewHFRbC++BRsi/53AQA6DeY/NgVdUoeLlGqmgDkve2edN7N00MhpVjFVwbF2HYBX58EQXuuyxQY8CV8NgBUrVuDuu+/2HwOoAcDQZFAD4HQWrPd0ALKyLrh/SQn4ccxraHjjzUL/M/GjnH+fnQHbuEcgG7eWYwFdqA4HHx2N6IdHQm8wiCjhpS7epIUp08P8DoAtW7YYS5NQmVsZ3ACQt2+ALfVuh3w4CTT/li7IGDMdmohI8fykf+pT5yLOHZ0KnD1b5hBZoCQ2Fode+q8IEzNpxJfEEU9g8ab38xoKAJYvX4577rnHfwxQZQDA3b3+/U/Iqskg9Ol/HDAcLUZPQu6Zs2IdgIpSwOW5M2D77+tc1bmM3HidtEbNYZ3+Ieo1biLUyKWIhHor/BoAeOpGPF5SDOvtrRyjf2KAJzYK60ZPR8vuPcU0cI71c0zdbSk6D9uoAZB/2lKuikEr4citd0D7wpuIqV1bgOBiii/CVwNg2bJl6Nevn/8YYPPmzUZlTfxgVgHyT6thU60PpJcknGnbDqdfehc2Q5ig/wYNGnim70NpsA7vC2Rll7MH9OF67BkyCnWHPo3YuHjXeZHZ3B0GQGwcEHJhIWpnsHij99XnKCqgBgBuup1t8hOQv/v6gvWvlbC612C0mzITGfZlYLgmsDfULa/8H2ycUFJcXM4e0ERFYe8TExFxbVvUzjiOWscOwsZJqDkZHC4FTtvzDwwGICIKiE+E1L0vpB79xbV87fnKA9Bu4bjE0qVL0b9//8AxAJHLRvSmIS+GIn0612KG3LkZcKZ0qpwY/ImPw0+j/o0Gt90l6N/dFHC395k7DfJ/Z7t0DS0RkUCYAZqiYshcecw+HczttaKjoOvRFznPTkNEJUcYyQABAcDGjRuNnTp1Eu9GGg1KAKxfAvmZoQ7jTa8B0ltdD+vrH6NE0opn5uwfn5I8DqdBfqI/kFF2vwG2g7LWR+maY94VRhb3vPwWwm/qKiZ5+vQsdi+AAFiyZAnXJ/YfA1QFAMgTHwOWfi+yf0TsX6/DxvuGo+XICcjOzRWzfji068r9s/MyYDEDh/ZCXv4NsGEVkJMNFJWUX3LOhbxljRYSZAcw+BzO4OBzZffsh6xh40U8wddBJoUB/A6ADRs2GJV9cYKSAUwlkLu3BrJLjTb2TlNiAo5MmoOo1m3EvHoKn72uTOFeQnmngVPHgWXfQl63AkhPL7OsvKJONFLpdc0uFmShYM926oaSlMYokLTQWszQH9qLxL2/QWM2O/INeP7fD49A/j2PQKvTiWFmX8YXCF5+Fi5cyPWJ/ccAQQ+Ar+dBfv0lxxLxBo0G69t2xPXzvhVz6ZlHVz85GTpla5jz54CTx4DtP0Ke/zFwmLOsyxbhQgqpa2AND0euPgwWkwlJ+WdR4gIE1qgo/DnkKVi69ka9ho1QXFCAmFeeRvim9Q7QGDTAz9M+hKEV13aAzwNMFD7trsWLF9cAQC0ueVgvYNtPjt6vDQ/Db89MRVz3PmJCJQM/jNxJx45A/n075E1rgJVLywV7hOqg0LUa2GLjsCUsFiHXtUf4dTcg+sZbkXMyHSmvPIO4jBOwugABcw7NN7TH4YFPIaxhEzScMxGmbaUp6QSU3KwZfnlxLiKjo8WAFDOPfUk5UwCwaNEiDBw40H8MsG7dOmOXLl3Ei3AoNajGArJOQh7Y1WGoUQhH6zdG5DdrAUmLnFMnkH/8L8Tt3YGmm1fAfPBgma7uELoEyHXrwlg7GUUtr0f8TZ0R36GzSILlrBwKjHSdu2cXWswah5IDh1xafgpzyMnJKDmV4ViXwBCixc/jZqBWx9tgsVqFNU+XlOzkbVE8L9oAAQUAG0VZDNHbh79s9eZOh/T+W6KhxaJHoTocHjoG0m19kb5+JZrt+xlNdm8FzhWhyCaX1rGvFayVJMhxMTiY3BRHWrZDwvU3IL79LdCHhYm5eAQ6mYNCYu4Av4vFH4/uA16fBGzZ5Pa1xEJU9qMMIx/pcifyR06BLlQvPCm6pBVGJF1cWWlzxgEefPDBwDFA0ACg8BykJ+4Bdv0qmouNbjIYcKZ7H8T+sR+Rh/cDVhuK7eY4jzPpU6ORUNTqGmxr2hbSNe0Qf307kSjKWAGFQ/eMAqfV7XaeII3Hz/4D6Yv/B5w/754NtBIOdeiGoqemIDQmVqgkeiT0AHyNowQMAGvXrjUqmyNSBQQNANYvhTR5FJBfcEEAXKZVAkJkWRhf7IUKzcuREchpfwt+ankT6rVph8TmrYTAle3eKRgOFvHjtXC2roG0dD7kTWsRVpDHNWZL76gBbM1bYvONdyC29wPQR0aKoWiyiLIota+sqEzHZyh40KBB/mOAYAWANHE4sHRBhTRMo05u0BC7ut2Nsy3aok6jpoiMj3ds28YBHUXwbmMEHiRlKyqE7eh+bD1wBCknDuOsyYLMqxqjTv0UxCWniHgAdwKhwUfqr2xWUcAAsGrVKqOyO2ZQMIDVAnw1F9Lc2eXSuBSLO0SjgemmDvi5Ux+EXt0WMfF1EKLXCyOWOp2C54c63eve7gQE2gjlFnmUZZwv5MaQEHTPCCTvp6iVyt5LfWsywODBg/3HAGoAkC6VRaIuxcv4RIPUux+/BWnFAiAnq8zGkMK4kySYoiKR26Mfcm65CxpuBhVeC5JWK9QWhcBsHsWY8+neqsouBe8CHMpPymrglb2fcp4yn5AZQQEFABtTWRb9Yl/K4/nM0Tt7Gpov50Ka/xmQn+8yUpeXnIKsngNQ3L0fQrQhItLGQlpnTyf9+uJyuXsu9TLyHp/9MlWgG5iamuo/Bvjhhx+Md9xxh3gdMoDfAJCbCc2CzyB9/n65NC112xoMOmyb/gliWrR2rKTBXs7e7kugpSJ5BYPg+XxkAaqA6g0ACn7LGkhfzAMOlM7aIcVzTSp68mq9S7cu/a5+yH10LHR6g6jLuP/FZusoYAgWwSvCJwCYE/jII49UQwbghk7b1kPz0WxIOy4s7EghM2hzulFTWG02RP151OHecczfOOUdxDZvLSxt6nlvV/2sCj1e/YxKIonfAbBixQqjskX6ZVMBR/dB88VcSIvmO2L0Sli1JCERazr1RpP2NyP+o9mIPrwfNrl0VY9tDz6BmAcfh0WWBTPQx/Z1nD0Ye7srcBIAjFv88MMPePTRR/3HAGoAKK7NpcwIkhb9f2g+fxfSkSOO9+bImVynDna07YyiLj3RqlsPHHtrKm6c/5EI6YZKEopbtEDa828hOjFJBFkYq6/MMm+VTdG6TDae28vyOelWrly50r8AWLJkibFXr17iwS4pAE5nQ/va85A2rHbk3oler5XwV8fbcazH/ah/0y3Cjcvevhk3znwOJfkFpelekeHYPHQC6t/9APLy84U/T+r3JsjivIqXvwVZ2fspACADDB061H8M4AoA6pdQ4gG+xAWkrWuhmf0iJPtYPAOoYQyfNmqEjb0fQd3OPRAWHS0GZULMJqRMHg794UPgQuxhzNHveBs042fAptEK3c95exUlV1RVoavbWcnIJgMEFQCcEe0JENIX70L70dtAbulS96Wxeoj1eYoGPoGoevWFrmPUjnn88nvTUG/+pyK2T4PQlNIA+ybMQmSTFgIg1PkEgBLKrWhFrsr2vmA4j23CoWmuDzBs2DD/McDixYuNvXv3LqMCfG0QBRTaV8dAu/S7MlO3pcQE7HhwFCK79ICkDXHs4kFKz1u7FA2mPgNTYXEp9UeEY9PgfyL5/lRwNy0W1uMATnUvVRoAsJoR8vpEhHz/ddll25q3wqlRL0KX0kQkStCSpw9PY05evwy1XnkWtrzS0T5a/bu73AX9s1NRaDKLgBTz6nwdV6+qQGHv52fVqlV4/PHHA8cAfAifitkE3Zwp0M3/wnEaJ20eurYdip9/A9ZQvRAmKZzCZARPc2Qv9OOGQfq7dNcv1s9o3grZk96EHBUr9L7HTF+fHjL4K9MDCAgAFi1aZOzTp49DBfgKgJDvP0Xo7JcvDN5IGhy8vj3k8TNh0YUK1yY8PAxJSVcJaz507QJop02CVFDa86n3C5Pq4cC4mQht1Nwxfk+9X9mFnYNf3OWfUFEBNAJHjBjhPwa4WADoH+sD7W+lWTssmhAtdr/xGWpfe4PQ94zX05DTnPgL+pXfAR+/C6mEm2IyAgiYkq7C70//CxGt2wrhc3TtUoZ7qwoYCADGO7hMnF8BsHDhQmPfvn0rzQBh3Vo4ejMvQmMu75rrsbp9d0TWSUBSZARaF5yCvPQ7hNhj/wrtmxOT8MuofyHy2hvEy1NNMKnicizSEOxAUADALeuffPJJ/zHAxQIg/OaUcinYIr6vlSCHh0EyMS2L++KWiqA0JiDhXNPm2J06FtHXtRMBKHoSV6rw2S5kP9o+ZIAqBYCwrs0hnTvnsoOps2cF5VPnayX82rE7TINGICK5oXhxFsYErsSerzScfd9gkAFGjhzpPwZYsGCB8e67S5ddYeCFetuXovt6HgzvvV4mg0d9vvDvpdI9iEzXXIcNHXoj4fae0ITqxf04tn8xO3n48qzBXJftTgaocgCAbIP2158QsmUtav20FprMU5BMpUuwyKE62OrWRfp1HXCweVuENbsasUlXocRkEt4Bw7vs9d7E+INZeJfi2QgAqkKqgFGjRlUdBnC8vNmM01kZOJmZhbzcXFhtVuh0oWIiRlRcbYRHRgqhM5RLr4DCV1bFuBQNWNWvETAAzJ8/33jvvfdWWgW4a3gKWoluUfCMATCky9y9S5VIWdWFrn5+0j9VIlXAM8884z8GuFwAqE7C8ce7EAD5+flYv369fwHw7bffGu+7775LzgD+aLTqdA+uc0BPgDbAmDFj/McAagAQgb6GgquTEAL5LqR/GoFkgBoABFISAbo3GUABwLPPPlvDAAGSQ8BuGzAAfPPNN8YBCQ+KF8/vBpRdOS9g7XHF3TifgTgAm958E2PHjvUfA9QAIDiwxt0MOEC+xd8A+Prrr433Jw6qYYAA40ABwObZs/Hcc8/5jwHUADgbBCqg9nffQW8PTKllYt60CcWff46Cjz92/HwVZxu5KSULFsC0YgXOf/UVbE5LwlZ0Hi93UqMsFek/VFAFCAbwNwC++uor4wNJg8WbBhsAKEQWNSDOTZiA/FmzxO+KIOXsbJg2b3ZIS13fun8/TvftC/Mff5QDjvN5SoXcAQP8J3n7nQgApsFunTUL48aN8x8DBDMAlJ6oa9wY8du2QWIaeXY2TiUklAEAgaIWmsZgQPRLLyFs4kRRj+yR3bVrOQA4n+d3qatuqABg08yZmDhxYg0AnKlYrRoUYCgM4E6Q6nPO3HYbijZurBA4gQQAZ1FQBWz2NwA+//xz4+D6qUGpAtS6OCEtDdpWrUBKz2zd2itBhnXtitj160VdV6ojmBhAAcCmGTMwadIk/zGAMwBcL4rmv75RV2UEpms00DJHcOxYRNjp/OxjjzkMwfp2I5CCzHKht6kK6nG5dy6CqaqjnGfatAlnx4wp83Ilv/3mv5dV3Yn6XzCAvwHw2WefGYekPOJggGACgLMkKMSchx5yWPWeAMDzXdVRfnMlaYIuEIUAoCu4Zfp0vPDCC/5jgGAGgOIFmA8dgnnHDpxbuLCMbC4WAFQnBbNnl7mm2s30JxACBoBPP/3U+FCDR4OSATz1Rk8A0Ldpg7q/ls5Z8EV1+FPwyr24FwpB8NO0aZg8ebL/GKA6AyBm3DhEvl66y3hm06Yw2WMBnoATKADQENwWSADkdgNKk7QDV2gEGuyRwOMe9HGK3QgsdmEERvTvj7jvvxcv4ny8ovMC9eZkAH62vvoqpkyZEhgGqKoAcNbl4ampCE7+iT0AAAJiSURBVO3cWciSx061a1cmHByMAOBmuPQCtvkbAJ988onx4YZDRWNxOJgRqUCWyjCAq+e1ZWej8KOPcHbq1HJjAcEIgONcogfAjldewYsvvug/BlADQD4CnHz8wlr4gQSCN/c2tGnjspqNqW2q2L831wpkHbp/p+wP4HcAzJgxwzj+5kmO97duBAr+DXhaJcCXLdW49o8vxcWOLW5P9+U5yu4YXPET+XJdX57XuS6TQEoX07EzwKRJRTNmzOgGgJsdKYd8aT5RV9k8o6ITuclu06FDh34xbNiwZh0st4IMoBRb6doNsF1Y0xG2X1THVY8m21tW3WjuvitgUINCXVf9u9JYzsJQBKn+Xd2w6u9KXXfH1b8r93Z3XeW4u2u5emd31zKrJKNcj+um/njPPcbFixePBnD0cgMgBkDjiIiI/k8++eT4O+64Q99y9Z1ItO+ZrBa8AIJd+DYXghfHVS+kfHcnWFfCdyV45+tWVcHzPRQhuxI8jT8OVv8J4H3gnwwI2n+qtEnmDQNQ1MkArtVoNB06d+7cq06dOtE+c03NCZekBdLT0zONRuMiALsApDEvxa4VKnV9bwCgB0A10JiqgAtyASAoQip1x5qTKtsCJAeSG23BdLvuP2YPDKoJw6frewMATtfn+mu1ASRxIW4AkZzC76UN4dMD1VR22wIEAOfkEwDcm54fxoSYoO2LfVnmBt4AgHU49EUmYM+n8Pm9hgH8j1b2dAqc5gAdAzphvjgi5Z7YGwAoJxEEZAMKnn8DMx7q/0YPpjtS2FQD/NAernTPV17KFwAEU0PUPMslaoH/A3ayc9puG+BsAAAAAElFTkSuQmCC'
	end

	def pdf_icon
		"<span><img class='pdf_icon' src='#{pdf_icon_source}'>Spec Sheet PDF</span>"
	end

	def current_user
  		@current_user ||= User.where(id: session[:user_id]).first
	end

    def generate_checks_and_form_attrs(product_spec)
        @ps = product_spec
        if @ps.class.name.match(/(DVR|Recorder)/)
            recorder_checks(@ps)
            recorder_form_attrs
        elsif @ps.class.name.match(/Camera/)
            camera_checks(@ps)
            camera_form_attrs
        else
            acc_check(@ps)
            acc_form_attrs
        end
        @product_check = @ps.product_type
    end

    def acc_check(product_spec)
        @ps = product_spec
    end

    def camera_checks(product_spec)
        @ps = product_spec
        @check_for_basic_info = @ps.check_for_basic_info
        @check_for_night_vision = @ps.check_for_night_vision
        @check_for_additional_image_features = @ps.check_for_additional_image_features
        @check_for_remote_monitoring = @ps.check_for_remote_monitoring
        @check_for_physical_attributes = @ps.check_for_physical_attributes
        @check_for_ptz = @ps.check_for_ptz
        @check_for_audio = @ps.check_for_audio
        @check_for_connectivity = @ps.check_for_connectivity
        @check_for_power = @ps.check_for_power
    end

	def recorder_checks(product_spec)
        @ps = product_spec
        @check_for_basic_info = @ps.check_for_basic_info
        @check_for_recording_resolution = @ps.check_for_recording_resolution
        @check_for_recording_modes = @ps.check_for_recording_modes
        @check_for_remote_monitoring = @ps.check_for_remote_monitoring
        @check_for_compatibility = @ps.check_for_compatibility
        @check_for_av_ports = @ps.check_for_av_ports
        @check_for_communication_ports = @ps.check_for_communication_ports
        @check_for_accessories = @ps.check_for_accessories
        @check_for_ptz = @ps.check_for_ptz
        @check_for_power = @ps.check_for_power
        @check_for_physical = @ps.check_for_physical           
	end

	def map_to_select(arr)
        arr.map{|arr_contents|[arr_contents,arr_contents]}
    end

    def recorder_form_attrs
        @channels = map_to_select([1,2,4,8,9,10,12,16,32])
        @display_channels = map_to_select([1,4,8,9,16,"Auto Sequence"])
        @recording_resolutions = map_to_select(['12MP','8MP','6MP','5MP','4MP','3MP','1080p','720p','D1'])
        @display_resolutions = map_to_select(['4k','1080p','1920x1080','1280x1024','720p','1024x768','1280x720'])
        @video_compression = map_to_select(['H.265','H.264+','H.264','MJPEG','MJPEG4'])
        @recording_modes = map_to_select(['Manual','Time Schedule','Motion Detection','Sensor'])
        @backup_methods = map_to_select(['PC','USB Flash','Hard Drive'])
        @dual_stream_options = map_to_select(['D1 @ 15 FPS','CIF @ 30 FPS'])
        @yes_or_no = map_to_select(['Yes','No'])
        @supported_softwares = map_to_select(['QC View','QT View'])
        @supported_mobile_devices = map_to_select(['Android','iPhone','iPad'])
        @supported_operating_systems = map_to_select(['Windows XP','Windows Vista','Windows 7,8,10','Mac OSX 10.7+'])
        @network_ports = map_to_select(["10","100","1000"])
        @remote_control = map_to_select(["USB Mouse","Remote Control"])
        @connectors_or_cables = map_to_select(["HDMI Cable"])
        @mounting_hardware = map_to_select(["Screws for Hard Drive"])
        @other_accessories = map_to_select(["Quick Start Guide"])
        @ptz_protocols = map_to_select(["COC","Null ","Pelco P","Pelco D","Lilin","Minking","Neon","Star","VIDO","DSCP","VISCA","Samsung","RM110","HY"])
    end

    def camera_form_attrs
        @yes_or_no = map_to_select(['Yes','No'])
        @camera_types = map_to_select(["Dome","Bullet","PTZ","PT"])
        @image_sensor_sizes = map_to_select(['1/3"','1/4"'])
        @sensor_types = map_to_select(["CMOS","CCD"])
    end

    def acc_form_attrs
    end

    def white_list_attrs
        @ps_json = ProductSpec.new.as_json
        @ps_hash = @ps_json.to_hash.symbolize_keys.except(:id)

        @ps_white_list = []

        @ps_hash.each do |k,v|
            modded_key = k.to_s.gsub(/(_file_name|_content_type|_file_size|_updated_at)/,'')
            if v.is_a? Array
                new_hash = {k.to_sym => v}
                @ps_white_list.push(new_hash)
            elsif !@ps_white_list.include?(modded_key.to_sym)
                @ps_white_list.push(modded_key.to_sym)
            end
        end

        @ps_white_list.map{|ps|ps}
    end

end