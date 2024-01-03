library MaxMindDBReader;

{
  This is an unofficial library for reading MaxMind GeoIP databases
  as a DLL library. It provides a simple and easy-to-use interface for
  reading MaxMind GeoIP databases in your applications. You can use it
  in your Delphi, C#, C++ and other programming languages projects.
  Contacts:
    Telegram: @tnAnGel
    Email: darkzeit00@gmail.com
}

uses
  System.SysUtils, System.Classes,
  uMMDBReader, uMMDBInfo, uMMDBIPAddress,
  System.JSON;

{$R *.res}

type TReader = class(TObject)
  private
    constructor Create(PathDB: WideString);
    destructor Destroy; override;
    function GetCountry(IP: WideString): WideString;
    function GetCity(IP: WideString): WideString;
    function GetASN(IP: WideString): WideString;
  protected
    FPatchDB: WideString;
    LMMDBReader: TMMDBReader;
end;

{ TReader }

constructor TReader.Create(PathDB: WideString);
begin
  LMMDBReader := TMMDBReader.Create(PathDB);
end;

destructor TReader.Destroy;
begin
  LMMDBReader.Free;
  inherited Destroy;
end;

function TReader.GetASN(IP: WideString): WideString;
var prefixLength: Integer;
    ipAddress: TMMDBIPAddress;
    asnInfo: TMMDBASN;
    jsonObject: TJSONObject;
begin
  ipAddress := TMMDBIPAddress.Parse(IP);
  asnInfo := TMMDBASN.Create;
  try
    if LMMDBReader.Find<TMMDBASN>(ipAddress, prefixLength, asnInfo) then
     begin
       jsonObject := TJSONObject.Create;
       try
         jsonObject.AddPair('Network', IP);
         jsonObject.AddPair('AutonomousSystemNumber', asnInfo.AutonomousSystemNumber.ToString);
         jsonObject.AddPair('AutonomousSystemOrganization', asnInfo.AutonomousSystemOrganization);
          Result := jsonObject.ToJSON;
       finally
         jsonObject.Free;
       end;
     end else Result := '{"error":"Not found"}';
  finally
    asnInfo.Free;
  end;

end;

function TReader.GetCity(IP: WideString): WideString;
var prefixLength: Integer;
    ipAddress: TMMDBIPAddress;
    ipCityInfo: TMMDBIPCountryCityInfoEx;
    jsonObject: TJSONObject;
    cityNameEN: string;
begin
  ipAddress := TMMDBIPAddress.Parse(IP);
  ipCityInfo := TMMDBIPCountryCityInfoEx.Create;
  try
    if LMMDBReader.Find<TMMDBIPCountryCityInfoEx>(ipAddress, prefixLength, ipCityInfo) then
     begin
       jsonObject := TJSONObject.Create;
       try
         jsonObject.AddPair('Network', IP);
         if not ipCityInfo.City.Names.TryGetValue('en', cityNameEN) then cityNameEN := '';
         if cityNameEN <> '' then
           jsonObject.AddPair('CityName', cityNameEN);
         jsonObject.AddPair('ContinentCode', ipCityInfo.Continent.code);
         jsonObject.AddPair('CountryISOCode', ipCityInfo.Country.ISOCode);
         jsonObject.AddPair('CountryGeonameId', ipCityInfo.Country.GeonameId.ToString);
         jsonObject.AddPair('RegisteredCountryISOCode', ipCityInfo.RegisteredCountry.ISOCode);
         jsonObject.AddPair('RegisteredCountryGeonameId', ipCityInfo.RegisteredCountry.GeonameId.ToString);
         jsonObject.AddPair('CityGeonameId', ipCityInfo.City.GeonameId.ToString);
         jsonObject.AddPair('LocationAccuracy', ipCityInfo.Location.Accuracy.ToString);
         jsonObject.AddPair('LocationTimeZone', ipCityInfo.Location.TimeZone);
         jsonObject.AddPair('PostalCode', ipCityInfo.Postal.Code);
         Result := jsonObject.ToJSON;
       finally
         jsonObject.Free;
       end;
     end else Result := '{"error":"Not found"}';
  finally
    ipCityInfo.Free;
  end;
end;

function TReader.GetCountry(IP: WideString): WideString;
var prefixLength: Integer;
    ipAddress: TMMDBIPAddress;
    ipCountryInfo: TMMDBIPCountryInfoEx;
    jsonObject: TJSONObject;
begin
  ipAddress := TMMDBIPAddress.Parse(IP);
  ipCountryInfo := TMMDBIPCountryInfoEx.Create;
  try
    if LMMDBReader.Find<TMMDBIPCountryInfoEx>(ipAddress, prefixLength, ipCountryInfo) then
     begin
       jsonObject := TJSONObject.Create;
       try
         jsonObject.AddPair('Network', IP);
         jsonObject.AddPair('ContinentCode', ipCountryInfo.Continent.code);
         jsonObject.AddPair('ContinentGeonameId', ipCountryInfo.Continent.GeonameId.ToString);
         jsonObject.AddPair('CountryISOCode', ipCountryInfo.Country.ISOCode);
         jsonObject.AddPair('CountryGeonameId', ipCountryInfo.Country.GeonameId.ToString);
         jsonObject.AddPair('RegisteredCountryISOCode', ipCountryInfo.RegisteredCountry.ISOCode);
         jsonObject.AddPair('RegisteredCountryGeonameId', ipCountryInfo.RegisteredCountry.GeonameId.ToString);
         Result := jsonObject.ToJSON;
       finally
         jsonObject.Free;
       end;
     end else Result := '{"error":"Not found"}';
  finally
    ipCountryInfo.Free;
  end;
end;


{ Export methods }

function GetCountry(PathDB, IP: WideString): WideString; safecall;
var Reader: TReader;
begin
  Reader := TReader.Create(PathDB);
  try
    Result := Reader.GetCountry(IP);
  finally
    FreeAndNil(Reader);
  end;
end;

function GetCity(PathDB, IP: WideString): WideString; safecall;
var Reader: TReader;
begin
  Reader := TReader.Create(PathDB);
  try
    Result := Reader.GetCity(IP);
  finally
    FreeAndNil(Reader);
  end;
end;

function GetASN(PathDB, IP: WideString): WideString; safecall;
var Reader: TReader;
begin
  Reader := TReader.Create(PathDB);
  try
    Result := Reader.GetASN(IP);
  finally
    FreeAndNil(Reader);
  end;
end;

exports GetCountry, GetCity, GetASN;

begin

end.
