@REM powershell -Command "(gc code-gen-config-template-local.yaml -Raw) -replace '__packageName__', '%packageNameSpace%' | Out-File -encoding ASCII %codeGenConfigFile%"

call openapi-generator-cli generate ^
-g aspnetcore ^
-i event-api-v1.swagger.3.0.3.yaml ^
-o output ^
--additional-properties=^
buildTarget=library^
,packageName=OpenApiGeneratorTesting^
,operationResultTask=true^
,useCollection=true^
,useSwashbuckle=true^
,nullableReferenceTypes=true ^