@open_path_with_value_as_id = (event) ->
	event.preventDefault()
	path = event.target.getAttribute("data-js-open-path-with-value-as-id")
	id = event.target.value
	link = path + id
	Turbolinks.visit link



# The EventListener is used for <selects> which choose a jasser for tables such as angstgegner. As we now use dropdowns, 
# we do not use this function anymore
#
# document.addEventListener "turbolinks:load", (event) ->
#	document.querySelector("[data-js-open-path-with-value-as-id]").addEventListener "change", (e) -> open_path_with_value_as_id e
