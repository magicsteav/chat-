# Nastavení IP a portu
$server_ip = "10.0.1.1"
$server_port = 12345

# Vytvoření TcpListener
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse($server_ip), $server_port)
$listener.Start()

Write-Host "Server listening on ${server_ip}:${server_port}"

# Vytvoření dynamického seznamu klientů
$clients = New-Object System.Collections.Generic.List[System.Net.Sockets.TcpClient]

function Broadcast($message) {
    foreach ($client in $clients) {
        $writer = [System.IO.StreamWriter]::new($client.GetStream())
        $writer.AutoFlush = $true
        $writer.WriteLine($message)
    }
}

function Handle-Client {
    param ($client)
    $reader = [System.IO.StreamReader]::new($client.GetStream())
    $nickname = $reader.ReadLine()
    Broadcast("${nickname} joined the chat")

    while ($client.Connected) {
        try {
            $message = $reader.ReadLine()
            if ($message -ne $null) {
                Broadcast("${nickname}: $message")
            }
        } catch {
            $clients.Remove($client)
            Broadcast("${nickname} left the chat")
            $client.Close()
        }
    }
}

while ($true) {
    $client = $listener.AcceptTcpClient()
    $clients.Add($client)
    Start-Job -ScriptBlock { param($client) Handle-Client $client } -ArgumentList $client
}
