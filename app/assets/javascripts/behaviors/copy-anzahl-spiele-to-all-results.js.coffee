@copy_spiele_to_all_results = (event) ->
	all_spiele_results = document.querySelectorAll("[data-js-copy-anzahl-spiele-to-all-results]").forEach (entry) ->
		entry.value = event.target.value



document.addEventListener "turbolinks:load", (event) ->
	document.querySelectorAll("[data-js-copy-anzahl-spiele-to-all-results]").forEach (entry) ->
		entry.addEventListener "change", (e) -> 
			copy_spiele_to_all_results(e)
