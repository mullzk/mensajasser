@open_angstgegner_for_jasser = (jasser_id) ->
    link = "/ranking/angstgegner/" + jasser_id
    window.location.pathname = link

$ ->
	$("#angstgegner_id").change (e) ->
		e.preventDefault()
		open_angstgegner_for_jasser(this.value)