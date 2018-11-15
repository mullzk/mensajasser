@toggle_navigation_submenu = (event) ->
	submenu = document.querySelector("[data-js-toggle-submenu] [toggle-view]")
	if submenu.style.display!="block"
		submenu.style.display = "block"
	else
		submenu.style.display = "none"
	event.preventDefault()
	event.stopPropagation()


document.addEventListener "turbolinks:load", (event) ->
	document.querySelector("[data-js-toggle-submenu] a[toggle-link]").addEventListener "click", (e) -> toggle_navigation_submenu(e)
