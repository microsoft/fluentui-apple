#!/bin/bash

id=""
alias=""
password=""
outputDirectory=""
renameLanguageFolder=true
extension=""
parserId=0
isoauth=false
tokenServer="tdb-touchdownbuild-prod"

function ParseArgs()
{
while getopts "nut:a:p:f:r:o:e:s:w:" arg
do
case "$arg" in
n)
renameLanguageFolder=false;;
u)
isoauth=true;;
t)
id=$OPTARG;;
a)
alias="$OPTARG";;
p)
password="$OPTARG";;
f)
filePath="$OPTARG";;
r)
relativeFilePath="$OPTARG";;
o)
outputDirectory="$OPTARG";;
e)
extension="$OPTARG";;
s)
parserId="$OPTARG";;
w)
tokenServer="$OPTARG";;
-)      break;;
esac
done
}

ParseArgs $*

echo Team ID: $id
echo Alias: $alias
echo File Path: $filePath
echo Relative Path: $relativeFilePath
echo Parser Id: $parserId
echo Output Directory: $outputDirectory
if($isoauth = true); then
echo "using oauth."
else
echo "using NTLM."
fi

# parse json and return value of the key
function jsonValue() {
KEY=$1
num=$2
jsonParseCmd=`awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p`
echo $jsonParseCmd
}

function oauthToken() {
tokenFetchCmd=`curl -sw "%{http_code}" -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "client_id=$alias&resource=https://microsoft.onmicrosoft.com/$tokenServer&client_secret=$password&grant_type=client_credentials" "https://login.microsoftonline.com/microsoft.onmicrosoft.com/oauth2/token"`
tokenValue=`echo $tokenFetchCmd | jsonValue access_token 1`
echo $tokenValue
}

if [ -d $filePath ]; then

echo "Getting all input files from $filePath"
inputFiles=$filePath/*

for file in $inputFiles
do
if [[ $extension != "" ]] && [[ $extension != "${file##*.}" ]]
then
continue
fi

echo "Processing $file"
fileName="${file##*/}"
relPath=$relativeFilePath/"$fileName"

echo "Relative file path $relPath"

if [ "$isoauth" = false ]; then
response=$(curl --ntlm -u $alias:$password -H "x-TDBuildWrapper: FluentUI-Apple" -X put https://build.intlservices.microsoft.com/api/teams/$id/LocalizableFiles/ParserId/$parserId --form 'FilePath={"FilePath":"'$relPath'"};type=application/json' --form "file=@$file;type=application/octet-stream" -o "$fileName.zip")
echo "Response result LocalizableFiles call $response"
else
tokenValue=$(oauthToken)
response=$(curl -H "Authorization: Bearer $tokenValue" -H "Accept: application/json" -H "x-TDBuildWrapper: FluentUI-Apple" -X put https://build.intlservices.microsoft.com/api/teams/$id/LocalizableFiles/ParserId/$parserId --form 'FilePath={"FilePath":"'$relPath'"};type=application/json' --form "file=@$file;type=application/octet-stream" -o "$fileName.zip")
echo "Response result LocalizableFiles call $response"
fi

if [ -f $fileName.zip ]; then
unzip -o $fileName.zip -d $outputDirectory
rm $fileName.zip
fi

done

elif [ -f $filePath ]; then

if [ "$isoauth" = false ]; then
response=$(curl --ntlm -u $alias:$password -H "x-TDBuildWrapper: FluentUI-Apple" -X put https://build.intlservices.microsoft.com/api/teams/$id/LocalizableFiles/ParserId/$parserId --form 'FilePath={"FilePath":"'$relativeFilePath'"};type=application/json' --form "file=@$filePath;type=application/octet-stream" -o loc.zip)
echo "Response result for LocalizableFiles call $response"
else
tokenValue=$(oauthToken)
response=$(curl -H "Authorization: Bearer $tokenValue" -H "Accept: application/json" -H "x-TDBuildWrapper: FluentUI-Apple" -X put https://build.intlservices.microsoft.com/api/teams/$id/LocalizableFiles/ParserId/$parserId --form 'FilePath={"FilePath":"'$relativeFilePath'"};type=application/json' --form "file=@$filePath;type=application/octet-stream" -o loc.zip)
echo "Response result for LocalizableFiles call $response"
fi

if [ -f loc.zip ]; then
unzip -o loc.zip -d $outputDirectory
rm loc.zip
fi

else

echo "$filePath is not valid"
exit 1

fi


if [ "$renameLanguageFolder" = true ]; then
echo "Renaming language folders in $outputDirectory"
languageFolders=$outputDirectory/*/

for folder in $languageFolders
do
folderWithoutSlash=${folder%/}

if [[ "lproj" == "${folderWithoutSlash##*.}" ]]
then
	continue
fi

echo "Renaming $folderWithoutSlash to $folderWithoutSlash.lproj"

if [ -d $folderWithoutSlash.lproj ]
then
	echo "Deleting $folderWithoutSlash.lproj as it already exists"
	rm -r $folderWithoutSlash.lproj
fi

mv $folderWithoutSlash $folderWithoutSlash.lproj

done
fi
