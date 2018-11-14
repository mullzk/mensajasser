
replace_mailto_link_with_decrypted_adresses = (link_node) ->
	decryptedstring = decrypt_mailto_link(link_node.getAttribute("data-js-decrypt-mailto-links"))
	link_node.href = "mailto:" + decryptedstring

decrypt_mailto_link = (mailto_link) ->
	mailto_link.replace(/_AAA_/g, '@').replace(/_PPP_/g, '.').replace(/_KKK_/g, ',').replace(/_SSS_/g, ' ')	

document.addEventListener "turbolinks:load", (event) ->
	replace_mailto_link_with_decrypted_adresses(document.querySelector("[data-js-decrypt-mailto-links]"))
	