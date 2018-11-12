@open_path_with_value_as_id = (event) ->
	event.preventDefault()
	path = event.target.getAttribute("data-js-open-path-with-value-as-id")
	id = event.target.value
	link = path + id
	Turbolinks.visit link



document.addEventListener "turbolinks:load", (event) ->
	document.querySelector("[data-js-open-path-with-value-as-id]").addEventListener "change", (e) -> open_path_with_value_as_id e
