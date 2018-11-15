@toggle_navigation_submenu = (event) ->
	submenu = event.target.nextElementSibling
	if submenu.hasAttribute("toggle-view") 
		if submenu.style.display!="block"
			submenu.style.display = "block"
		else
			submenu.style.display = "none"
	event.preventDefault()
	event.stopPropagation()


document.addEventListener "turbolinks:load", (event) ->
	document.querySelector("[data-js-toggle-submenu] a[toggle-link]").addEventListener "click", (e) -> toggle_navigation_submenu(e)
