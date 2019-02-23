


RegisterServerEvent("hospital:price")
AddEventHandler("hospital:price", function()
	 local user = vRP.users_by_source[source]
	 local payment = 1000
	if user:tryFullPayment(1000) then
	vRP.EXT.Base.remote._notify(user.source,"~r~Paid ~g~1000.")

    else
        vRP.EXT.Base.remote._notify(user.source,"~r~Free care approved, you pay $0.")
    end
end)
