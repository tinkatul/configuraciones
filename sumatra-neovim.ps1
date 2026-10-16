param(
    [string]$Archivo,
    [int]$Linea
)

$nvr = "$env:LOCALAPPDATA\Python\pythoncore-3.14-64\Scripts\nvr.exe"
$servidor = '\\.\pipe\nvim-sumatra'
$ruta = $Archivo.Replace('\', '/')

& $nvr --nostart --servername $servidor `
    -c "edit $ruta" `
    -c "$Linea"
