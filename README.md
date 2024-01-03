# MaxMind GeoIP Reader DLL Library         
This is an unofficial library for reading MaxMind GeoIP databases as a DLL library. It provides a simple and easy-to-use interface for reading MaxMind GeoIP databases in your applications. You can use it in your Delphi, C#, C++ and other programming languages projects. The library is provided in 2 types for Windows x86 and x64 and databases for tests.

# Description of the methods
 _Import data:_
+ PathDB - string, the path to your database. It must be absolute.
+ IP - string, IP to search for data. Example: 8.8.8.8
_Export functions:_
```
    GetASN: function (PathDB, IP: WideString): WideString; safecall;
    GetCountry: function (PathDB, IP: WideString): WideString; safecall;
    GetCity: function (PathDB, IP: WideString): WideString; safecall;
```


# How to use
 _Delphi_
``` pascal
procedure TForm1.Button1Click(Sender: TObject);
var DLLHandle: THandle;
    PWC : array[0..255] of WideChar;
    PluginName: string;
    GetASN: function (PathDB, IP: WideString): WideString; safecall;
    GetCountry: function (PathDB, IP: WideString): WideString; safecall;
    GetCity: function (PathDB, IP: WideString): WideString; safecall;
begin
  PluginName := ExtractFilePath(Application.ExeName) + 'MaxMindDBReader.dll';
  StringToWideChar(PluginName, PWC, PluginName.Length+1);

  DLLHandle := LoadLibrary(PWC);
  if DLLHandle = 0 then
    raise Exception.Create('The library could not be connected!');
  try
    @GetCity := GetProcAddress(DLLHandle, 'GetCity');
    Self.Memo1.Lines.Text := GetCity(ExtractFilePath(ParamStr(0)) + '/IpGeo2/GeoLite2-City.mmdb', '8.8.8.8');
  finally
    FreeLibrary(DLLHandle);
  end;
end;
```

_C++_
``` cpp
#include <windows.h>
#include <string>
#include <iostream>

typedef std::wstring (*GetCityFunc)(std::wstring, std::wstring);

int main() {
    HMODULE dllHandle = LoadLibrary(L"MaxMindDBReader.dll");
    if (dllHandle == NULL) {
        std::cerr << "The library could not be connected!" << std::endl;
        return 1;
    }

    GetCityFunc getCity = reinterpret_cast<GetCityFunc>(GetProcAddress(dllHandle, "GetCity"));
    if (getCity == NULL) {
        std::cerr << "The function could not be found!" << std::endl;
        FreeLibrary(dllHandle);
        return 1;
    }

    std::wstring city = getCity(L"IpGeo2/GeoLite2-City.mmdb", L"8.8.8.8");
    std::wcout << city << std::endl;

    FreeLibrary(dllHandle);
    return 0;
}
```

_C#_
``` csharp
using System;
using System.Runtime.InteropServices;

public delegate string GetCityDelegate(string pathDB, string ip);

public class Program
{
    [DllImport("MaxMindDBReader.dll", CharSet = CharSet.Unicode)]
    public static extern GetCityDelegate GetCity;

    public static void Main()
    {
        string city = GetCity("IpGeo2/GeoLite2-City.mmdb", "8.8.8.8");
        Console.WriteLine(city);
    }
}
```

# The result of execution in JSON:
_GetASN:_
``` json 
{
  "Network": "8.8.8.8",
  "AutonomousSystemNumber": "15169",
  "AutonomousSystemOrganization": "GOOGLE"
}
```

_GetCountry:_
``` json
{
  "Network": "8.8.8.8",
  "ContinentCode": "NA",
  "ContinentGeonameId": "6255149",
  "CountryISOCode": "US",
  "CountryGeonameId": "6252001",
  "RegisteredCountryISOCode": "US",
  "RegisteredCountryGeonameId": "6252001"
}
```

_GetCity:_
``` json
{
  "Network": "8.8.8.8",
  "ContinentCode": "NA",
  "CountryISOCode": "US",
  "CountryGeonameId": "6252001",
  "RegisteredCountryISOCode": "US",
  "RegisteredCountryGeonameId": "6252001",
  "CityGeonameId": "0",
  "LocationAccuracy": "1000",
  "LocationTimeZone": "America/Chicago",
  "PostalCode": ""
}
```
_If an error occurs:_
``` json 
{
  "error": "Not found"
}
```



# Repositories used: 
- https://github.com/optinsoft/MMDBReader
- https://github.com/rvelthuis/DelphiBigNumbers

# Contacts
- Telegram: @tnAnGel 
- Email: darkzeit00@gmail.com

# Donate
BTC: bc1q4s290l8042am3qewkjmqllylh43kfgf7vjqwhn