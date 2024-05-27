Příkazy potřebné pro hladký běh programu: 
1= samozřejmě spustit powershell jako administrátora
2= cd (místo kde máte programy uložené, klidně i zástupce) příklad: cd C:\Users\doube\Desktop
2= Set-ExecutionPolicy RemoteSigned -Scope CurrentUser ( aby server mohl odesílat klientovy zprávy potřebuje povolení) možnost a 
3= .\chat_server.ps1 (pro serverovou aplikaci)
4= .\chat_client.ps1 (pro klientovskou aplikaci)

