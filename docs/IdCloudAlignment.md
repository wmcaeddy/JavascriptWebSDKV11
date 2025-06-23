# IdCloud KYC API Alignment - Flutter IDV

**App**: Flutter IDV (`com.magi-3.idvflutter`)

This document explains how our Flutter IDV application implementation aligns with the official IdCloud KYC API documentation.

## API Endpoint Alignment

### ✅ Step 1: Initiate Document Verification
**Documentation**: `POST /scs/v1/scenarios`

**Our Implementation**: 
- `ApiService.initiateDocumentVerification()` in `lib/services/api_service.dart`
- Called when user captures front document image
- Request body matches documentation exactly:
```json
{
  "name": "Connect_Verify_Document",
  "input": {
    "captureMethod": "SDKMobile",
    "type": "Passport",
    "size": "TD1",
    "frontWhiteImage": "BASE64_IMAGE"
  }
}
```

**Flow**: Document capture → Base64 encoding → API call → Scenario ID returned

### ✅ Step 2: Send Additional Images
**Documentation**: `PATCH /scs/v1/scenarios/{scenario_id}/state/steps/{image_type}`

**Our Implementation**:
- `ApiService.sendDocumentImage()` method
- Helper methods for specific image types:
  - `submitBackDocument()` for `backWhiteImage`
  - `submitIRImage()` for `frontIRImage`/`backIRImage`
  - `submitUVImage()` for `frontUVImage`/`backUVImage`

**Request Structure**:
```json
{
  "name": "Connect_Verify_Document",
  "input": {
    "backWhiteImage": "BASE64_IMAGE"
  }
}
```

### ✅ Step 3: Get Verification Results
**Documentation**: `PATCH /scs/v1/scenarios/{scenario_id}/state/steps/verifyResults`

**Our Implementation**:
- `ApiService.getVerificationResults()` method
- Handles both 200 and 204 response codes
- Automatically polls scenario status for 204 responses
- Request body matches documentation:
```json
{
  "name": "Connect_Verify_Document"
}
```

### ✅ Scenario Status Monitoring
**Documentation**: `GET /scs/v1/scenarios/{scenario_id}`

**Our Implementation**:
- `ApiService.getScenarioStatus()` method
- Used for monitoring scenario progress
- Returns complete scenario state including steps and results

## Authentication Implementation

### ✅ Headers Match Documentation
Our implementation includes the exact headers specified in the documentation:

```dart
'Authorization': 'Bearer ${config.apiConfig.jwtToken}',
'X-API-KEY': config.apiConfig.xApiKey,
'Content-Type': 'application/json',
'Accept': 'application/json'
```

## Response Handling

### ✅ Status Code Handling
- **201**: Scenario created successfully (Step 1)
- **200**: Request processed successfully (Step 2)
- **204**: Request accepted, polling required (Step 3)
- **400+**: Error handling with detailed error messages

### ✅ Response Structure Parsing
Our implementation correctly parses the documented response structure:

```dart
// Extract scenario ID
final scenarioId = response['id'] as String;

// Check scenario status
final status = response['status'] as String; // "Waiting" or "Finished"

// Extract verification results
final documentData = extractDocumentData(response);
final verificationResults = extractVerificationResults(response);
```

## Workflow Integration

### ✅ Three-Step Process Implementation

1. **Document Capture with Immediate Verification**:
   - User captures document with Acuant SDK
   - Front image automatically sent to `POST /scenarios`
   - Scenario ID stored for subsequent calls

2. **Optional Additional Images**:
   - Framework supports sending back, IR, UV images
   - Uses `PATCH /scenarios/{id}/state/steps/{type}` endpoints

3. **Results Retrieval**:
   - Triggers verification with `PATCH /scenarios/{id}/state/steps/verifyResults`
   - Polls scenario status until completion
   - Extracts final verification results

## Data Structure Alignment

### ✅ Image Format
- Base64 encoded images as specified
- Proper data URL handling (removes `data:image/jpeg;base64,` prefix)
- Supports maximum 10MB request size limit

### ✅ Document Types
- Configurable document types (Passport, DrivingLicense, etc.)
- Size specifications (TD1, TD2, TD3)
- Capture method properly set to "SDKMobile"

## Error Handling

### ✅ API Error Responses
```dart
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String responseBody;
}
```

Handles all documented error scenarios:
- 400: Bad Request (client errors)
- Authentication failures
- Network connectivity issues
- Request size limit exceeded

## JavaScript Integration

### ✅ WebView Communication
The HTML interface properly calls Flutter API methods:

```javascript
// Step 1: Initiate verification
const result = await callFlutterApi('submit_front_document', {
  front_image: frontImageBase64,
  document_type: 'Passport',
  document_size: 'TD1'
});

// Step 2: Send additional images
await callFlutterApi('send_document_image', {
  scenario_id: scenarioId,
  image_type: 'backWhiteImage',
  image_base64: backImageBase64
});

// Step 3: Get results
await callFlutterApi('get_verification_results', {
  scenario_id: scenarioId
});
```

## Configuration Alignment

### ✅ API Configuration
The `config.json` structure matches documentation requirements:

```json
{
  "api_config": {
    "base_url": "https://scs-ol-demo.rnd.gemaltodigitalbankingidcloud.com/scs/v1",
    "x_api_key": "12345678-90ab-cdef-1234-567890abcdef",
    "jwt_token": "eyJ0...3jig"
  }
}
```

## Security Compliance

### ✅ Credential Management
- JWT tokens and API keys stored securely
- No hardcoded credentials in source code
- Encrypted storage using Flutter Secure Storage
- Git-safe configuration (sensitive files excluded)

## Testing and Validation

### ✅ Real API Integration
- No mock data or dummy endpoints
- Uses actual IdCloud KYC demo environment
- Real HTTP requests with proper authentication
- Comprehensive error handling and logging

## Summary

Our implementation is **fully aligned** with the IdCloud KYC API documentation:

✅ **Exact API endpoints** as documented  
✅ **Correct request/response formats**  
✅ **Proper authentication headers**  
✅ **Three-step workflow implementation**  
✅ **Complete error handling**  
✅ **Security best practices**  
✅ **Real API integration (no mocks)**  

The application provides a production-ready implementation that follows the IdCloud KYC "Connect_Verify_Document" scenario exactly as specified in the official documentation. 