/* this should be provided by popper.js, but somehow it doesn't 
   since switching back to non-dockerized rails. 
*/

toggle_navbar = function (event) {
	let currentNavbarCollapse = event.target.nextElementSibling;
	document.querySelectorAll(".navbar .navbar-collapse").forEach ((navbarCollapse) => {
        navbarCollapse.classList.toggle("show");
	});
	event.preventDefault();
	event.stopPropagation();
}


document.addEventListener("turbolinks:load", (event) => {
	document.querySelectorAll(".navbar-toggler[data-toggle=collapse]").forEach ((element) => {
		element.addEventListener("click", (e) => { toggle_navbar(e) });
	});
});
