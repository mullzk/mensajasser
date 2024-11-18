/* this should be provided by popper.js, but somehow it doesn't 
   since switching back to non-dockerized rails. 
*/

toggle_dropdown = function (event) {
	let current_dropdown_menu = event.target.nextElementSibling;
	document.querySelectorAll(".dropdown .dropdown-menu").forEach ((dropdown_menu) => {
		if (dropdown_menu.style.display!="block") {
			if (dropdown_menu == current_dropdown_menu) {
				dropdown_menu.style.display = "block"
			}
		} else {
			dropdown_menu.style.display = "none"
		}
	});
	event.preventDefault();
	event.stopPropagation();
}


document.addEventListener("turbolinks:load", (event) => {
	document.querySelectorAll(".dropdown a[data-toggle=dropdown]").forEach ((element) => {
		element.addEventListener("click", (e) => { toggle_dropdown(e) });
	});
});
