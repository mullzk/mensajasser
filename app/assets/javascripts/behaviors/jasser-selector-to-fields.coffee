@jasser_selector_to_fields = (event) ->
	result_index = event.target.getAttribute("data-js-jasser-selector-to-fields")
	jasser_id = event.target.value
	jasser_name = ""
	event.target.querySelectorAll("option").forEach (option) ->
		if option.value==jasser_id
			jasser_name = option.text
	selector = "[data-js-jasser-name='"+result_index+"']"
	all_jasser_fields = document.querySelectorAll(selector).forEach (entry) ->
		entry.innerHTML = jasser_name
		console.log(entry)

# This function would be used if we could put multiple forms on one page (_forms_multi), which we currently can not
#
#document.addEventListener "turbolinks:load", (event) ->
#	document.querySelectorAll("[data-js-jasser-selector-to-fields]").forEach (entry) ->
#		entry.addEventListener "change", (e) -> 
#			jasser_selector_to_fields(e)
