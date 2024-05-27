# Nastavení IP a portu serveru
$server_ip = "10.0.1.1"
$server_port = 12345

# Pøipojení k serveru
$client = [System.Net.Sockets.TcpClient]::new($server_ip, $server_port)
$stream = $client.GetStream()
$reader = [System.IO.StreamReader]::new($stream)
$writer = [System.IO.StreamWriter]::new($stream)
$writer.AutoFlush = $true

# Pøeètení pøezdívky
$nickname = Read-Host "Enter your nickname"
$writer.WriteLine($nickname)

function Receive-Messages {
    while ($client.Connected) {
        try {
            $message = $reader.ReadLine()
            if ($message -ne $null) {
                Write-Host $message
            }
        } catch {
            Write-Host "Disconnected from server"
            $client.Close()
            break
        }
    }
}

# Spuštìní pøíjmu zpráv v samostatném vláknì
Start-Job -ScriptBlock { Receive-Messages }

# Odesílání zpráv
while ($client.Connected) {
    $message = Read-Host -Prompt ">"
    $writer.WriteLine($message)
}
