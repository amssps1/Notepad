<#Param ([String]$AlertName,[String]$SubscriptionID)
 
$Logstring = $AlertName + " " + $SubscriptionID
$Logfile = "c:\temp\LogAlerts.log"
$DateTime = Get-Date -Uformat "%y-%m-%d %H:%M:%S"
$Logstring = $DateTime + " " + $Logstring
Add-content $Logfile -value $Logstring
#>

Param(
[string]$user="administrator",
[string]$password="cofidis",
[string]$campaign=1,
[string]$phone=910510955,
[string]$smsc="TMN",
[string]$message="Test"
)

#"User é: " + $user
#"Password: " + $password
#"A mensagem é: " + $message
#"O telefone é: " + $phone

function Remove-StringSpecialCharacter
{
<#
.SYNOPSIS
	This function will remove the special character from a string.
.DESCRIPTION
	This function will remove the special character from a string.
	I'm using Unicode Regular Expressions with the following categories
	\p{L} : any kind of letter from any language.
	\p{Nd} : a digit zero through nine in any script except ideographic 
	http://www.regular-expressions.info/unicode.html
	http://unicode.org/reports/tr18/
.PARAMETER String
	Specifies the String on which the special character will be removed
.SpecialCharacterToKeep
	Specifies the special character to keep in the output
.EXAMPLE
	PS C:\> Remove-StringSpecialCharacter -String "^&*@wow*(&(*&@"
	wow
.EXAMPLE
	PS C:\> Remove-StringSpecialCharacter -String "wow#@!`~)(\|?/}{-_=+*"
	wow
.EXAMPLE
	PS C:\> Remove-StringSpecialCharacter -String "wow#@!`~)(\|?/}{-_=+*" -SpecialCharacterToKeep "*","_","-"
	wow-_*
.NOTES
	Francois-Xavier Cat
	@lazywinadm
	www.lazywinadmin.com
	github.com/lazywinadmin
#>
	[CmdletBinding()]
	param
	(
		[Parameter(ValueFromPipeline)]
		[ValidateNotNullOrEmpty()]
		[Alias('Text')]
		[System.String[]]$String,

		[Alias("Keep")]
		#[ValidateNotNullOrEmpty()]
		[String[]]$SpecialCharacterToKeep
	)
	PROCESS
	{
		IF ($PSBoundParameters["SpecialCharacterToKeep"])
		{
			$Regex = "[^\p{L}\p{Nd}"
			Foreach ($Character in $SpecialCharacterToKeep)
			{
				IF ($Character -eq "-"){
					$Regex +="-"
				} else {
					$Regex += [Regex]::Escape($Character)
				}
				#$Regex += "/$character"
			}

			$Regex += "]+"
		} #IF($PSBoundParameters["SpecialCharacterToKeep"])
		ELSE { $Regex = "[^\p{L}\p{Nd}]+" }

		FOREACH ($Str in $string)
		{
			Write-Verbose -Message "Original String: $Str"
			$Str -replace $regex, ""
		}
	} #PROCESS
}


#$message=$message.trim('"')
#$message=$message.trim("'")

$message = $message | Remove-StringSpecialCharacter -SpecialCharacterToKeep " ","(",")",":",".","*","_"

$log=(get-date -Format "yyyy/MM/dd HH:mm") + " Notification: $message" + " to phone $phone"
$logdate=(get-date -Format "yyyyMMdd")
if ($message -like '*AS Alert*') {
	$log | Out-File c:\SCOM\SendSMS\PrevencaoAs_$logdate.txt -Append
}
elseif ($message -like '*SD Alert*') {
	$log | Out-File c:\SCOM\SendSMS\PrevencaoSd_$logdate.txt -Append
}
elseif ($message -like '*SP Alert*') {
	$log | Out-File c:\SCOM\SendSMS\PrevencaoSp_$logdate.txt -Append
}
else {
    $log | Out-File C:\SCOM\SendSMS\Outros_$logdate.txt -Append
}

$URI = "https://nereu.cofidis.pt/M-itWebService/M_ItWebService.asmx?wsdl"
$proxy = New-WebServiceProxy -Uri $URI -Class holiday -Namespace webservice
try {
$proxy.sendMessage($user,$password,1,$phone,$smsc,$message)
}
catch {
$i=0
while ($i -le $_.count) {
$log=(get-date -Format "yyyy/MM/dd HH:mm") + " Error: $message" + " to phone $phone with Error: " + $error[$i] | 
        Out-File C:\SCOM\SendSMS\Erros_$logdate.txt -Append
$i++
}
}