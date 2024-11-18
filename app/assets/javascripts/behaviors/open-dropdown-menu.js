/* this should be provided by popper.js, but somehow it doesn't 
   since switching back to non-dockerized rails. 
*/

toggle_dropdown = function (event) {
	var dropdown_menu = event.target.nextElementSibling;
	console.log(event.target);
	console.log(dropdown_menu);
	if (dropdown_menu.classList.contains("dropdown-menu")) {
		if (dropdown_menu.style.display!="block") {
			dropdown_menu.style.display = "block"
		} else {
			dropdown_menu.style.display = "none"
		}
	}
	event.preventDefault();
	event.stopPropagation();
}


document.addEventListener("turbolinks:load", (event) => {
	document.querySelectorAll(".dropdown a[data-toggle=dropdown]").forEach ((element) => {
		element.addEventListener("click", (e) => { toggle_dropdown(e) });
	});
});
