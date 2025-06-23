# Flutter IDV - Identity Verification App

**Bundle ID**: `com.magi-3.idvflutter`  
**App Name**: Flutter IDV

Flutter IDV is a comprehensive identity verification application that integrates the Acuant JavaScript Web SDK with IdCloud KYC API for secure document verification.

## Features

- **Document Capture**: Live camera capture of identity documents with automatic detection and quality analysis
- **Face Verification**: Passive liveness detection and face matching
- **IdCloud KYC Integration**: Real API transactions with JWT and X-API-KEY authentication
- **Secure Configuration**: Encrypted storage of sensitive credentials
- **Cross-Platform**: Supports both Android and iOS with proper bundle identifiers

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode for platform-specific builds
- Valid Acuant SDK credentials
- Valid IdCloud KYC API credentials (JWT token and X-API-KEY)

## Quick Setup

### 1. Clone and Setup

```bash
git clone <your-repository>
cd flutter_idv
flutter pub get
```

### 2. Configure Credentials

⚠️ **SECURITY NOTICE**: See [SECURITY.md](SECURITY.md) for detailed security guidelines.

Copy and edit the configuration file:
```bash
cp config.example.json config.json
```

Update `config.json` with your actual credentials (NOT the example file):
```json
{
  "api_config": {
    "base_url": "https://scs-ol-demo.rnd.gemaltodigitalbankingidcloud.com/scs/v1",
    "x_api_key": "YOUR_ACTUAL_X_API_KEY",
    "jwt_token": "YOUR_ACTUAL_JWT_TOKEN"
  },
  "acuant_config": {
    "passive_username": "YOUR_ACUANT_PASSIVE_USERNAME",
    "passive_password": "YOUR_ACUANT_PASSIVE_PASSWORD",
    "id_username": "YOUR_ACUANT_ID_USERNAME", 
    "id_password": "YOUR_ACUANT_ID_PASSWORD",
    "passive_subscription_id": "YOUR_ACUANT_SUBSCRIPTION_ID",
    "frm_endpoint": "https://frm.acuant.net",
    "acas_endpoint": "https://acas.acuant.net",
    "liveness_endpoint": "https://us.passlive.acuant.net"
  }
}
```

### 3. Build and Run

```bash
flutter run  # For debug
flutter build apk --release  # Android release
flutter build ios --release  # iOS release
```

---

# Acuant JavaScript Web SDK v11.9.3

**February 2024**

See [https://github.com/Acuant/JavascriptWebSDKV11/releases](https://github.com/Acuant/JavascriptWebSDKV11/releases) for release notes.

----------

## License

This software is subject to Acuant's end user license agreement (EULA), which can be found [here](EULA.pdf).

----------

## Introduction

This document provides detailed information about the Acuant JavaScript Web SDK. The JavaScript Web SDK enables developers to integrate image capture and processing functionality in their mobile web applications.

----------

## Supported Devices

- **Global requirement:** To work with the SDK, the device/browser must support WASM/WebAssembly.

- **Android:** All devices supported. Depending on device capabilities, users might be directed to 'Live Capture', 'Tap to Capture' or 'Manual Capture'.

- **iOS devices still supported by Apple:** All devices supported. Depending on device capabilities, users might be directed to 'Live Capture', 'Tap to Capture' or 'Manual Capture'.

- **iOS devices no longer supported by Apple:** Not officially supported. Testing shows that running the image worker alone is successful, but running the metrics worker simultaneously with the image worker may fail. Acuant recommends using the single worker model, and users are directed to use Manual Capture.

----------

## Migration information

See [Migration Details](docs/MigrationDetails.md) for more information.

----------

## Modules

The SDK includes the following modules:

**Acuant JavaScript SDK (AcuantJavaScriptSdk.min.js):**

- Main script used to call all the other parts of the SDK

**Acuant Camera (AcuantCamera.min.js/AcuantCamera.js, html5-qrcode.min.js, imageMagick.umd.js, imageMagick.mjs):**

- Live Document Capture functionality
- Uses AssureID Document Library to detect documents, crop, calculate sharpness and glare
- Additional Camera UI provided by Acuant
- Embed barcode reader
- HEIC support on desktop

**Acuant Passive Liveness (AcuantPassiveLiveness.min.js, opencv.min.js, face_landmark_68_tiny_model-weights_manifest.json, face_landmark_68_tiny_model.bin, tiny_face_detector_model-shard1, tiny_face_detector_model-weights_manifest.json):**

- Enables face capture with real-time face detection and liveness detection

**Acuant Initializer Worker (AcuantInitializerWorker.min.js, AcuantInitializerService.js, AcuantInitializerService.wasm):**

- WASM-based Web Worker used to initialize the SDK with a set of credentials or a Bearer token
- Used by the Implementer via **Acuant JavaScript SDK**

**Acuant Image Worker (AcuantImageWorker.min.js, AcuantImageService.js, AcuantImageService.wasm):**

- WASM-based Web Worker used to run Cropping and Document Detection
- Used by **Acuant Camera** or by the Implementer via **Acuant JavaScript SDK**

**Acuant Metrics Worker (AcuantMetricsWorker.js, AcuantMetricsService.js, AcuantMetricsService.wasm):**

- Web Worker used to run image quality metrics like sharpness and glare
- Used by **Acuant Image Worker** after cropping or by the Implementer via **Acuant JavaScript SDK**

----------

## Setup

1. Add the following files, excluding ones that will not be used (**Note**:  These files must be accessible in the public resource directory of the hosted application):

    - **AcuantJavaScriptSdk.min.js**
    - **AcuantCamera.min.js**
      - **html5-qrcode.min.js**
      - **imageMagick.umd.js** (optional)
      - **imageMagick.mjs** (optional)
    - **AcuantPassiveLiveness.min.js**
      - **opencv.min.js**
      - **face_landmark_68_tiny_model-weights_manifest.json**
      - **face_landmark_68_tiny_model.bin**
      - **tiny_face_detector_model-shard1**
      - **tiny_face_detector_model-weights_manifest.json**
    - **AcuantInitializerWorker.min.js**
    - **AcuantInitializerServicejs**
    - **AcuantInitializerService.wasm**
    - **AcuantImageWorker.min.js**
    - **AcuantImageService.js**
    - **AcuantImageService.wasm**
    - **AcuantMetricsWorker.min.js**
    - **AcuantMetricsService.js**
    - **AcuantMetricsService.wasm**

    **Note** To ensure that SDK can instantiate WebAssembly modules efficiently, make sure the hosting server is serving `.wasm` files with the correct mime type `application/wasm`.

1. Load the main script files, excluding ones that will not be used:

    ```html
      <script src="AcuantJavascriptWebSdk.min.js"></script>
      <script async src="AcuantCamera.min.js"></script>
      <script async src="AcuantPassiveLiveness.min.js"></script>
      <script async src="opencv.min.js" charset="utf-8"></script>
      <script async src="html5-qrcode.min.js"></script>
    ```

    **Note:** OpenCV is only needed for AcuantPassiveLiveness module.

1. Define a custom path to load files (if different than root):

    ```js
      const acuantConfig = {
        path: "/custom/path/to/sdk/"
      }
    ```

1. Define a callback *before* the script tag in step 2. This is an optional global JavaScript function that is executed after WASM is loaded.

    ```js
      var onAcuantSdkLoaded = function() {
        //sdk has been loaded;
      }
    ```

    **Note:** The SDK loads using a listener for DOMContentLoaded. If the scripts will be added to the page in a way that the listener won't be called (for example, in a single-page react application), once the SDK scripts are loaded in the page, manually call the following function:

    ```js
      loadAcuantSdk();
    ```

1. Define a method as a callback for unexpected errors in situations where one of the other error callbacks could not be called. This callback should rarely, if ever, be called. If the callback is getting called, review the implementation as it more often than not indicates a flaw in the implementation.

    ```js
      AcuantJavascriptWebSdk.setUnexpectedErrorCallback((error) => {
        //handle the error
      });
    ```

----------

## Initialize and Start the SDK

1. Set the credentials (either bearer token or basic auth format in base64) and ACAS endpoint, then initialize the SDK with one of the following methods:

    **Note:** AcuantInitializerWorker is started and ended automatically as needed.

    ```js
      AcuantJavascriptWebSdk.initialize(
        token: string, //Acuant credentials in base64 (basic auth format id:pass)
        endpoint: string, //endpoint for Acuant's ACAS server
        callback: object, //callback shown below
        fromCDN: int //set to 1 if hosting via cdn, defaults to 0
      );

      //or

      AcuantJavascriptWebSdk.initializeWithToken(
        token: string, //bearer token
        endpoint: string, //endpoint for Acuant's ACAS server
        callback: object, //callback shown below
        fromCDN: int //set to 1 if hosting via cdn, defaults to 0
      );

      let callback = {
        onSuccess: function() {
          //proceed with using the sdk
        },
        onFail: function(code, description) {
          //handle the error
        }
      }
    ```

    Use the following ACAS endpoints based on region:

    ```
    USA: https://us.acas.acuant.net
    EU: https://eu.acas.acuant.net
    AUS: https://aus.acas.acuant.net
    ```

    Use the following ACAS endpoint for testing purposes:

    ```
    PREVIEW: https://preview.acas.acuant.net
    ```

1. After the *initialize* or *initializeWithToken* function succeeds, start the Web Workers. By default, the *start* function starts all the Workers. Alternatively, you can provide a boolean to enable the single worker model. The single worker model starts only one worker at a time and is intended for low-end devices that struggle to run both workers at the same time. Note that this model might degrade the overall performance.

    ```js
      AcuantJavascriptWebSdk.start(
        callback: () => {} //no params, void function, called when workers are ready.
        singleWorkerModel: boolean, //set to true if you want to run one worker at a time. Default to false.
        fromCDN: int //set to 1 if hosting via cdn, defaults to 0
      );
    ```

1. Ending the Workers. (**Note**: Do not end Workers unless they are no longer needed. Do end the workers when they are no longer needed or when the user will leave the page.)

    ```js
      AcuantJavascriptWebSdk.end();
    ```

----------

## Live Capture using WebRTC

Live Capture offers guidance to users to position documents, and initiates autocapture when detected. This feature is present only when WebRTC is available in the browser.

### **Supported browsers**

The JavaScript Web SDK supports the following web browsers for live capture of ID documents:

- **Android**: Chrome
- **iOS**: Safari, with iOS version >= 13.0

For other browsers that do not support WebRTC, the device's camera app (manual capture) is used.

### **Camera Preview**

The camera preview by default will fill the width of the screen preserving a 4:3 aspect ratio. It's possible to customize the camera dimensions but if these do not adhere to the aspect ratio, one dimensions will be overridden.

### **Tap to Capture**

- Tap to capture will be enabled for devices that can support the resolution constraints, but cannot support the image processing.
- When the camera is launched, the image processing speed is automatically checked. If the speed is above the threshold set at 400ms, live document detection and autocapture features are disabled and switched to tap to capture. The user will have to manually capture the document.

----------

## AcuantCameraUI

**Prerequisite**: Initialize the SDK (see [Initialize and Start the SDK](#initialize-and-start-the-sdk))

- This code is used for live capture; live detection, frame analysis, and auto capture of documents. After capture, it also processes the image.
- AcuantCameraUI is the default implementation of the UI and uses AcuantCamera to access the device's native camera via WebRTC.

### Start Live Capture

1. Add a viewport meta tag (if not already present) to prevent the video/ui from rendering at a much higher resolution than it needs to:

    ```html
      <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no"/>
    ```

1. Add HTML to show the live capture preview:

    ```html
      <div id="acuant-camera" style="height:custom-height; width:custom-width"></div>
    ```

1. Set custom strings. (Optional)

    ```js
      let options = {
        text:{
          NONE: "ALIGN",
          SMALL_DOCUMENT: "MOVE CLOSER",
          BIG_DOCUMENT: "TOO CLOSE",
          GOOD_DOCUMENT: null,//if let null will show a countdown
          CAPTURING: "CAPTURING",
          TAP_TO_CAPTURE: "TAP TO CAPTURE"
        }
      };
    ```

1. Set up callback to retrieve the image at each state of the camera. Be aware that cropping the image can fail and cause the **onCropped response to be undefined**. For more information on the processed image returned via **onCropped**, see [Image from AcuantCameraUI and AcuantCamera](#image-from-acuantcameraui-and-acuantcamera).

    ```js
      var cameraCallback = {
        onCaptured: (response) => {
          //document captured
          //this is not the final result of processed image
          //show a loading screen until onCropped is called
        },
        onCropped: (response) => {
          if (response) {
          //use response
          } else {
          //cropping error
          //restart capture
          }
        },
        onFrameAvailable: (response) => {
          //this is optional
          //Use only if you plan to display custom UI elements in addition to what is already displayed by the camera.
          response = {
            type: Number,
            dimensions: Object,
            dpi: Number,
            isCorrectAspectRatio: Boolean,
            points: Array,
            state: Number => {
              NO_DOCUMENT: 0,
              SMALL_DOCUMENT: 1,
              BIG_DOCUMENT: 2,
              GOOD_DOCUMENT: 3
            }
          }
        },
        onError: (error, code) => {
        //error will be more specific, while the code broader. See current list of codes below.
        //Please handle different or null codes, though they are not expected to occur.
        }
      }

      codes = [
        AcuantJavascriptWebSdk.START_FAIL_CODE, //This means the camera failed to start either because it is not supported or because the user declined permission.
        AcuantJavascriptWebSdk.REPEAT_FAIL_CODE, //This means Live Capture was called after an error with Live Capture already occurred. Important: When this happens, the user is directed to Manual Capture. Use this error callback to set up your display as you would for a user in Manual Capture.
        AcuantJavascriptWebSdk.SEQUENCE_BREAK_CODE //This means live capture froze/crashed. Usually occurs in iOS 15 due to a GPU Highwater failure. See known issues for more information.
        AcuantJavascriptWebSdk.HEIC_NOT_SUPPORTED_CODE: //This means HEIC image processing failed because the correspoding scripts were not added
      ]

    ```

1. Start live capture camera.

    ```js
      AcuantCameraUI.start(
        cameraCallback, //shown above
        options //shown above
      )
    ```

    **Note**: For all full captures, in the event of an error, direct the user to manual capture (detailed in the next section).

1. End Camera.

    ```js
      AcuantCameraUI.end();
    ```

    **Note**: Once AcuantCameraUI onCaptured is called, the end API is internally executed.

If you are not using AcuantCamerUI, and you want to use your own live capture UI, you can call AcuantCamera directly to use document detection, frame analysis, and auto capture (see [Use Your Own Custom Live Capture UI](#use-your-own-custom-live-capture-ui)).

----------

## AcuantCamera

**Prerequisite:** Initialize the SDK (see [Initialize and Start the SDK](#initialize-and-start-the-sdk)).

### Start Manual Capture

- This camera is used for manual capture. It opens the device's native camera app or a file explorer on desktop, which is useful when WebRTC is not available. Unlike AcuantCameraUI, it does not provide frame analysis or document detection. It does process the image after capture.

  **Note:** Launching Live Capture after a Live Capture error directs users to Manual Capture. For best practice, do not rely on this behavior, and send users to Manual Capture from within your implementation.

1. Start manual capture. Be aware that cropping the image can fail and cause the **onCropped response to be undefined**. For more information on the processed image returned via **onCropped**, see [Image from AcuantCameraUI and AcuantCamera](#image-from-acuantcameraui-and-acuantcamera).

    ```js
      AcuantCamera.startManualCapture({
        onCaptured: (response) => {
          //this will be called after user finishes capture
          //then proceeds to crop
          //onCropped will be called after finished
        },
        onCropped: (response) => {
          if (response) {
            //cropped response;
          } else {
            //Error occurred during cropping; retry capture
          }
        },
        onError: (error, code) => {
          //error will be more specific, while the code broader. See current list of codes below.
          //Please handle different or null codes, though they are not expected to occur.
        }
      });
    ```

  **Important**: AcuantCamera manual capture uses `<input type="file"/>` html tags to access the device's camera app. This REQUIRES a user initiated event to start the camera.

  **Note**: Acuant recommends not hiding any UI elements when starting manual capture. Be aware users will be able to cancel out of the device's camera app screen.

### Use Your Own Custom Live Capture UI

When you are not using the default AcuantCameraUI for the live capture preview, you can implement your own live capture preview and use AcuantCamera to do the frame analysis, document detection, and auto capture. Consider looking at the non-minified AcuantCameraUI in AcuantCamera.js.

The general flow of a custom camera ui is as follows:

1. Attach a listener for the following event on the camera:

    ```js
      acuantCamera.addEventListener('acuantcameracreated', () => { });
    ```

    This event will be issued after the camera setup is complete. At this point, the document will contain two elements: acuant-ui-canvas (a canvas element) and acuant-player (a video element). The video element will show the feed from the camera while the canvas is used to draw your custom ui.

1. Start the AcauntCamera

    ```js
      AcuantCamera.start(
        (response) => {}, //detect callback (see onFrameAvalible in part 3 of AcauntCameraUI for response body)
        (error, code) => {} //error callback (see part 4 of AcuantCameraUI)
      )
    ```

1. From here, use the detect callback to handle frames, update your UI, and trigger capture. When you are ready to trigger the capture, call the following method:

    ```js
      AcuantCamera.triggerCapture((response) => { })

      response = {
        data: ImageData,
        width: Number, 
        height: Number,
        isPortraitOrientation: Boolean
      }
    ```

1. Use the response as necessary. When you are ready, go to the section [Process the Image Manually](#process-the-image-manually)

#### **AcuantCamera Info**

  ```js
  var AcuantCamera = (() => {
    let isCameraSupported = boolean;

    const DOCUMENT_STATE = {
        NO_DOCUMENT: 0,
        SMALL_DOCUMENT: 1,
        BIG_DOCUMENT: 2,
        GOOD_DOCUMENT: 3
    };

    const ACUANT_DOCUMENT_TYPE = {
        NONE: 0,
        ID: 1,
        PASSPORT: 2
    };

    // open manual capture
    function startManualCapture(cameraCb)

    // used for live capture UI (AcuantCameraUI or custom)
    function start(detectCb, cameraCb, errorCb)//start the frame analysis
    function triggerCapture(cb)//capture
    function evaluateImage(imgData, width, height, isPortraitOrientation, capType, callback) //performs the sharpness, glare, barcode scan and other metrics.
    function end()//end camera
  })();
  ```

### Upload HEIC image files for processing on desktop

Follow these steps if you want to support HEIC image processing by uploading the image files on desktop. Be aware that this feature is supported only on Safari.

1. Add the following scripts.

    ```html
    <script async src="imageMagick.umd.js"></script>
    <script async type="module" src="imageMagick.mjs"></script>
    ```

2. Follow the [manual capture](#start-manual-capture) steps.

----------

## Process the Image

**Prerequisite:** Initialize the SDK (see [Initialize and Start the SDK](#initialize-and-start-the-sdk)).

### Image from AcuantCameraUI and AcuantCamera

When using AcuantCameraUI and AcuantCamera, after the document image is captured, it is automatically processed with crop, sharpness, glare, and barcode scan.

**Cropping, Sharpness, Glare and Barcode scan**

The processed image and data are returned via the camera **onCropped** callback. The image can be used to verify the crop, sharpness, and glare of the image, and then upload the document. If the image contains a barcode, it is scanned and included in the response.

Here is the response from the callback:

  ```js
  response = {
    image: { 
      data: String,
      bytes: ByteArray,
      width: Number,
      height: Number,
      barcodeText: String,
    }, 
    glare: Number, 
    sharpness: Number,
    cardType: Number, //define card type, None = 0, ID = 1, Passport = 2
    dpi: Number
  }
  ```

If the sharpness value is greater than 50, then the image is considered sharp (not blurry). If the glare value is 100, then the image does not contain glare. If the glare value is 0, then image contains glare. When image is obtained and has passed metrics, it is ready for upload.

**Note**: If using Acuant web service to authenticate documents, the image must be sharp and not contain glare to get best results in authentication and data extraction. When the image has glare, low sharpness, or both, retake the image. Acuant recommends against modifying and/or compressing the resulting image before uploading to the Acuant web service. Modifying and/or compressing the image may negatively affect authentication and data extraction results.

### Process the Image Manually

This information is for processing images manually if they are not captured through AcuantCameraUI and AcuantCamera. This is not relevant for most implementations.

1. When you are ready to evaluate the image, use the following method:

    ```js
      AcuantCamera.evaluateImage(
        imgData: ImageData, //received from trigger capture
        width: Number, //received from trigger capture
        height: Number, //received from trigger capture
        isPortraitOrientation: Boolean, //received from trigger capture
        capType: String, //Used for metrics on how the image was captured, put "CUSTOM" or leave blank for best results
        callback: Function //shown below
      )

      let callback = (response) => {}
    ```

  For the response structure, see [Image from AcuantCameraUI and AcuantCamera](#image-from-acuantcameraui-and-acuantcamera).

----------

## Face Capture with real-time face detection and Acuant Passive Liveness

Acuant recommends using the **LiveAssessment** property rather than the score to evaluate response. **AcuantPassiveLiveness.start** will return a rescaled image in onCaptured callback.

Follow these recommendations to effectively process an image for passive liveness:
#### Image requirements

- **Height**:  minimum 480 pixels; recommended 720 or 1080 pixels
- **Compression**:  Image compression is not recommended (JPEG 70 level or above is acceptable). For best results, use uncompressed images.

#### Face requirements

- Out-of-plane rotation:  Face pitch and yaw angle: from -20 to 20 degrees +/-3 degrees
- In-plane rotation:  Face roll angle: from -30 to 30 degrees +/- 3 degrees
- Pupillary distance:  Minimum distance between the eyes 90 +/- 5 pixels
- Face size: Minimum 200 pixels in either dimension
- Faces per image: 1
- Sunglasses: Must be removed

#### Capture requirements

The following may significantly increase errors or false results:

- Using a motion blur effect
- Texture filtering
- A spotlight on the face and nearest surroundings
- An environment with poor lighting or colored light

### Start face capture and send Passive Liveness request

**Important:** Do not use this module for face capture if you are not using the Acuant FaceID API. You can do either of the following:

- Include the subscription, with face enabled, in the call to get a result.

- Exclude the subscription to get only the captured image and process that image through an alternate orchestration layer.

1. Add an HTML element to show face capture preview:

    ```html
      <div id="acuant-face-capture-container"></div>
    ```

1. Optionally, create custom detection texts:

    ```js
      const faceDetectionStates = {
        FACE_NOT_FOUND: "FACE NOT FOUND",
        TOO_MANY_FACES: "TOO MANY FACES",
        FACE_ANGLE_TOO_LARGE: "FACE ANGLE TOO LARGE",
        PROBABILITY_TOO_SMALL: "PROBABILITY TOO SMALL",
        FACE_TOO_SMALL: "FACE TOO SMALL",
        FACE_CLOSE_TO_BORDER: "TOO CLOSE TO THE FRAME"
      }
    ```

	**Note:** The module does not provide the text UI element.

1. Set up callback:

    ```js
      var faceCaptureCallback = {
        onDetectorInitialized: () => {
          //This callback is triggered when the face detector is ready.
          //Until then, no actions are executed and the user sees only the camera stream.
          //You can opt to display an alert before the callback is triggered.
        },
        onDetection: (text) => {
          //Triggered when the face does not pass the scan. The UI element
          //should be updated here to provide guidence to the user
        },
        onOpened: () => {
          //Camera has opened
        },
        onClosed: () => {
          //Camera has closed
        },
        onError: (error) => {
          //Error occurred. Camera permission not granted will
          //manifest here with 1 as error code. Unexpected errors will have 2 as error code.
        },
        onPhotoTaken: () => {
          //The photo has been taken and it's showing a preview with a button to accept or retake the image.
        },
        onPhotoRetake: () => {
          //Triggered when retake button is tapped
        },
        onCaptured: (base64Image) => {
          //Triggered when accept button is tapped
        }
      }
    ```

1. Start face capture with real-time detection:

    ```js
      AcuantPassiveLiveness.start(faceCaptureCallback, faceDetectionStates);
    ```

    **Note:** The module also exposes ```startManualCapture``` method that launches the native camera and returns the image taken in base64.

1. Get the passive liveness result for the face image:

    **Note:** If you are using a third-party orchestration layer, skip this step. Instead, consult the step for obtaining liveness in the third party's documentation.

    ```js
      AcuantPassiveLiveness.getLiveness({
        endpoint: "ACUANT_PASSIVE_LIVENESS_ENDPOINT",
        token: "ACUANT_PASSIVE_LIVENESS_TOKEN",
        subscriptionId: "ACUANT_PASSIVE_LIVENESS_SUBSCRIPTIONID",
        image: base64Image
      }, (result) => { })

      result = {
        LivenessResult = {
          LivenessAssessment: String //see below for possible values
          Score: Number
        },
        Error: String, //error description
        ErrorCode: String //see below for possible values
      }

      ErrorCode = [
        "Unknown",
        "FaceTooClose",
        "FaceNotFound",
        "FaceTooSmall",
        "FailedToReadImage",
        "InvalidRequest",
        "InvalidRequestSettings",
        "Unauthorized",
        "NotFound"
      ]

      LivenessAssesment = [
        "Live",
        "NotLive",
        "PoorQuality",
        "Error"
      ]
    ```

    **Note:** To get the liveness result, credentials with FaceID must be enabled.

1. End Live capture:

    The camera closes automatically after the user takes a selfie or when the user taps Close. However, you also can close the live camera by calling the ```end``` function.

      ```js
      AcuantPassiveLiveness.end()
      ```

----------

## Performing face match

1. The following example shows how to perform a call to the Face Match API. Perform this call with the extracted document face image and with the face image that results from a passive liveness workflow. For the authorization field, either basic or bearer token authorization is valid. In both cases, a SubscriptionId is still required.

    **Note:** If you are using a third-party orchestration layer, skip this section. Instead, consult the steps for performing face match in the third party's documentation.

    ```js
      async function getFaceMatch(frmEndpoint, subscription, tokenBasic, callback) {
        const body = {
          'Settings': {
          'SubscriptionId': subscription
          },
          'Data': {
          'ImageOne': face1,
          'ImageTwo': face2
          }
        };

        try {
          const response = await fetch(frmEndpoint + '/api/v1/facematch', {
            method: 'POST',
            body: JSON.stringify(body),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Basic ' + tokenBasic,
              'Accept': 'application/json'
            }
        });

        const myJson = await response.json();
        callback(myJson);
        } catch (e) {
          console.log('Error while matching faces: ' + e);
          callback(null);
        }
      }
    ```

----------

## Use of CDNs (Content Delivery Networks)

Web Workers/WASM and CDNs can be used together with workarounds. The following changes would need to be added to your code to host the Web Workers/WASM through a CDN:

1. To locate the Workers, add the following code:

    ```html
      <script id="AcuantInitializerSource" type="worker">
        importScripts("https://your.CDN.URL/AcuantInitializerWorker.min.js");
      </script>
      <script id="AcuantImageSource" type="worker">
        importScripts("https://your.CDN.URL/AcuantImageWorker.min.js");
      </script>
      <script id="AcuantMetricsSource" type="worker">
        importScripts("https://your.CDN.URL/AcuantMetricsWorker.min.js");
      </script>
    ```

1. Add the following function in your code:

    ```js
      function getURL() {
        const initTxt = document.getElementById( 'AcuantInitializerSource' ).textContent;
        const initUrl = URL.createObjectURL( new Blob( [ initTxt ] ) );
        const imageTxt = document.getElementById( 'AcuantImageSource' ).textContent;
        const imageUrl = URL.createObjectURL( new Blob( [ imageTxt ] ) );
        const metricsTxt = document.getElementById( 'AcuantMetricsSource' ).textContent;
        const metricsUrl = URL.createObjectURL( new Blob( [ metricsTxt ] ) );
        const out = {
          initializerUrl: initUrl,
          imageUrl: imageUrl,
          metricsUrl: metricsUrl
        };
        return out;
      }
    ```

1. Before calling initialize, set cdnPath in acuantConfig to the result of the getURL():

    ```js
      acuantConfig.cdnPath = getURL();
    ```

1. Set the value of fromCDN (defaults to 0) in the following functions to 1.

    ```js
      AcuantJavascriptWebSdk.initialize(base64Token, acas_endpoint, callback, 1);
      //or
      AcuantJavascriptWebSdk.initializeWithToken(oauthToken, acas_endpoint, callback, 1);
    ```

1. Web Workers running from CDNs have issues with relative URLs. In order for the Web Worker to be able to find the associated files you will need to provide it with the absolute URL where the file will be hosted.

- Acuant provides a script within the repo called convert_for_cdn.sh. Run this script by giving it the path to the folder containing the sdk and the URL for where the WASM files will be on the CDN. It will then modify the workers for you. Note that the script conducts limited sanity checks, and if given the wrong parameters, might behave unexpectedly.

    ```bash
      #Convert to absolute urls for use with CDNs
      #$1=file directory
      #$2=absolute url up to file location on CDN including trailing slash (ie https://company.example/files/ but not https://company.example/files/file.wasm or https://company.example/files)


      bash convert_for_cdn.sh webSdk/ https://your.CDN.URL/
    ```

- If the script doesn't provide the desired outcome, or if you prefer to manually edit the files, you will need to change the following fields to their absolute equivalent in the following files.

    ```js
      ="AcuantInitializerService.wasm" in AcuantInitializerService.min.js
      ="AcuantImageService.wasm" in AcuantImageService.min.js
      ="AcuantMetricsService.wasm" in AcuantMetricsService.min.js

      importScripts("AcuantInitializerService.min.js") in AcuantInitializerWorker.min.js
      importScripts("AcuantImageService.min.js") in AcuantImageWorker.min.js
      importScripts("AcuantMetricsService.min.js") in AcuantMetricsWorker.min.js
    ```

----------

## Using the SDK as part of an iOS or Android WebView

See the [WebView ReadMe](docs/WebViewReadMe.md) for documentation on WebViews.

----------

## Improved support for devices with extreme memory constraints

See the single worker model in [Initialize and Start the SDK](#initialize-and-start-the-sdk).

----------

## Known Issues/FAQ

1. Some base model iPhones struggle to focus at close distances when running iOS 17.*.

    The minimum focus distance for many iPhone cameras was increased in iOS 17 and has resulted in a diminished ability for users to meet both the dpi and sharpness constraints required to capture a good image. However, iOS 17 also exposed the ability to use WebRTC to perform optical zoom on iPhone devices that support it. With 11.9.3 the SDK applies a small optical zoom on devices running iOS 17 to enable capturing a sharp image without sacrificing dpi.

1. iPhone 13 Pro, 13 Pro Max, 14 Pro, and 14 Pro Max struggle to focus at close distances when running iOS 16.0 through 16.3.

    11.7.1 adds a workaround for this issue by having those devices capture from farther away. This is a workaround for an issue in iOS 16. There is a more detailed explanation of both the issue and the workaround in the 11.7.1 section of the [Migration Details](docs/MigrationDetails.md). We have been in contact with Apple and as of iOS 16.4 Apple has provided us with the tools to fix this issue properly. This fix was released as part of 11.8.2.
    
1. iOS 15 has multiple issues that manifest themselves as GPU Highwater failures (ie system daemon used too much memory).

    The reduced resolution of the camera in the latest version of the SDK has mitigated the issue. Unfortunately, because this is an iOS issue, we can't provide a better solution other than reducing the capture resolution. This issue was fixed in iOS 16.

1. The camera preview has a low/throttled frame rate (as low as 10-15fps).

    The frame rate is intentionally throttled because higher frame rates on iOS 15 can be unstable. For consistency, the frame rate is throttled on all devices. In our experience, the throttled frame rate is high enough to successfully perform Live Capture. We will continue to monitor this issue and will remove the throttle once we believe higher frame rates no longer cause instability. This throttling was removed in 11.7.1

1. Camera previews on iOS 15.0 and 15.1 can appear rotated

    This issue occurs intermittently. Although the device is set to portrait, the preview can appear rotated as though the device is set to landscape. This is an iOS bug and our testing indicated it has been fixed in the iOS 15.2 beta.

1. Nothing happens when the page/scripts load.

    Verify that AcuantJavascriptWebSdk.min.js is not loaded asynchronously. Currently, loading the file asynchronously is not supported. The file is small and should not take long to load synchronously.

1. After encountering an error, further calls to Live Capture go to Manual Capture.

    This behavior is intended, and is not an issue. This behavior has been the intended workflow since release.

1. The following "wasm streaming compile failed: TypeError: Failed[...]" is printed in console.

    You can ignore these warnings. If you want to prevent the warnings, set the file type for the .wasm files to application/wasm in your server/cdn configuration.

1. When using Manual Passive Liveness camera on Google Chrome for Android, the camera defaults to the back-facing instead of the front-facing camera. 

    Users can tap to switch to the front-facing camera. This is a Chrome issue and unfortunately, we cannot provide a workaround at this time.

    See:
	- [https://bugs.chromium.org/p/chromium/issues/detail?id=1182828](https://bugs.chromium.org/p/chromium/issues/detail?id=1182828)
	- [https://stackoverflow.com/questions/56721653/why-doesnt-capture-user-change-my-phones-camera-to-front-facing](https://stackoverflow.com/questions/56721653/why-doesnt-capture-user-change-my-phones-camera-to-front-facing)

1. When embedding the AcuantCamera live capture preview onto an iframe, it may squish the preview causing capture and document detection issues.

    The workaround is to add iframe properties in the CSS. Add the following iframe properties in the CSS on the page that will use the iframe:

    ```css
      iframe {
        border: 0 !important;
        height: 100%;
        width: 100% !important;
      }
      .iframe-content {
        height: auto;
      }

      @media only screen and (max-width: 600px) {
        iframe {
        height: 100%;
        }
        .iframe-content {
        height: 96%;
        }
      }
    ```

    Then add the regular HTML content to the page embedded in the iframe.

1. My browser console displays GET tiny_face_detector_model-shard1 404.

    Make sure your hosting server is configured to serve extensionless files correctly. By default, IIS, and possibly other servers, are not configured to correctly serve extensionless files.

----------

## Reference of AcuantJavascriptWebSdk methods

**Note:** This information is provided only as a reference. All relevant functions are covered in more detail in specific sections of the Readme.

```js
  AcuantJavaScriptSdk {
    ACUANT_IMAGE_WORKER: "AcuantImageWorker",
    ACUANT_METRICS_WORKER: "AcuantMetricsWorker",

    startInitializer: function(cb, fromCDN = 0),
    endInitializer: function(),
    start: function(cb, singleWorkerModel = false, fromCDN = 0),
    end: function(workers = [ACUANT_IMAGE_WORKER, ACUANT_METRICS_WORKER]),
    initialize: function(credentials, endpoint, callback, fromCDN = 0),
    initializeWithToken: function(token, endpoint, callback, fromCDN = 0),
    crop: function(imgData, width, height, callback),
    metrics: function(imgData, width, height, callback),
    moire: function(imgData, width, height, callback),
    detect: function(imgData, width, height, callback),
    setUnexpectedErrorCallback: function(callback)
  }
```

----------

**Copyright 2022 Acuant Inc. All rights reserved.**

This document contains proprietary and confidential information and creative works owned by Acuant and its respective licensors, if any. Any use, copying, publication, distribution, display, modification, or transmission of such technology, in whole or in part, in any form or by any means, without the prior express written permission of Acuant is strictly prohibited. Except where expressly provided by Acuant in writing, possession of this information shall not be construed to confer any license or rights under any Acuant intellectual property rights, whether by estoppel, implication, or otherwise.

AssureID and *i-D*entify are trademarks of Acuant Inc. Other Acuant product or service names or logos referenced this document are either trademarks or registered trademarks of Acuant.

All 3M trademarks are trademarks of Gemalto/Thales Inc.

Windows is a registered trademark of Microsoft Corporation.

Certain product, service, or company designations for companies other
than Acuant may be mentioned in this document for identification
purposes only. Such designations are often claimed as trademarks or
service marks. In all instances where Acuant is aware of a claim, the
designation appears in initial capital or all capital letters. However,
you should contact the appropriate companies for more complete
information regarding such designations and their registration status.

For technical support, go to: [https://support.acuant.com](https://support.acuant.com)

**Acuant Inc. 6080 Center Drive, Suite 850, Los Angeles, CA 90045**

----------------------------------------------------------

# Acuant WebView Flutter Application

A Flutter application that integrates the Acuant JavaScript Web SDK with Gemalto API for identity verification. This app provides document capture, face verification, and liveness detection capabilities.

## Features

- **Document Capture**: Live camera capture of identity documents with automatic detection and quality analysis
- **Face Verification**: Passive liveness detection and face matching
- **Gemalto Integration**: Real API transactions with JWT and X-API-KEY authentication
- **Secure Configuration**: Encrypted storage of sensitive credentials
- **Cross-Platform**: Supports both Android and iOS

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode for platform-specific builds
- Valid Acuant SDK credentials
- Valid Gemalto API credentials (JWT token and X-API-KEY)

## Setup Instructions

### 1. Clone and Setup Flutter Project

```bash
git clone <your-repository>
cd acuant_webview_app
flutter pub get
```

### 2. Configure Credentials

**IMPORTANT**: Never commit your actual credentials to version control.

1. Copy the example configuration file:
```bash
cp config.example.json config.json
```

2. Edit `config.json` with your actual credentials:
```json
{
  "api_config": {
    "base_url": "https://scs-ol-demo.rnd.gemaltodigitalbankingidcloud.com/scs/v1",
    "x_api_key": "YOUR_ACTUAL_X_API_KEY",
    "jwt_token": "YOUR_ACTUAL_JWT_TOKEN"
  },
  "acuant_config": {
    "passive_username": "YOUR_ACUANT_PASSIVE_USERNAME",
    "passive_password": "YOUR_ACUANT_PASSIVE_PASSWORD",
    "id_username": "YOUR_ACUANT_ID_USERNAME", 
    "id_password": "YOUR_ACUANT_ID_PASSWORD",
    "passive_subscription_id": "YOUR_ACUANT_SUBSCRIPTION_ID",
    "frm_endpoint": "https://frm.acuant.net",
    "acas_endpoint": "https://acas.acuant.net",
    "liveness_endpoint": "https://us.passlive.acuant.net"
  }
}
```

### 3. Android Setup

The Android configuration is already included in the project:

- **Permissions**: Camera, microphone, and internet permissions are configured in `AndroidManifest.xml`
- **WebView**: Supports modern WebView features required by Acuant SDK

### 4. iOS Setup

The iOS configuration is already included in the project:

- **Permissions**: Camera and microphone usage descriptions are configured in `Info.plist`
- **WebView**: Supports inline media playback for face detection

### 5. Build and Run

```bash
# For Android
flutter run

# For iOS
flutter run --target ios

# For release builds
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Application Architecture

### Core Components

1. **ConfigService**: Securely manages API credentials and configuration
2. **ApiService**: Handles all HTTP requests to Gemalto API with proper authentication
3. **WebViewScreen**: Main interface integrating Acuant SDK with Flutter
4. **HTML Interface**: Modified Acuant SDK implementation with Gemalto integration

### Data Flow

1. **Initialization**: App loads configuration and initializes Acuant SDK
2. **Verification Start**: Calls Gemalto API to start verification scenario
3. **Document Capture**: Uses Acuant SDK to capture and process documents
4. **Face Verification**: Performs passive liveness detection
5. **Data Submission**: Sends captured data to Gemalto API for verification
6. **Transaction Completion**: Finalizes the verification process

## API Integration

The application makes real HTTP requests to the IdCloud KYC API endpoints following the exact documentation:

**Step 1: Initiate Document Verification**
- `POST /scs/v1/scenarios` - Initiate document verification with front image

**Step 2: Send Additional Images** 
- `PATCH /scs/v1/scenarios/{scenario_id}/state/steps/{image_type}` - Send additional document images (back, IR, UV)

**Step 3: Get Verification Results**
- `PATCH /scs/v1/scenarios/{scenario_id}/state/steps/verifyResults` - Trigger verification results retrieval
- `GET /scs/v1/scenarios/{scenario_id}` - Get scenario status and results

All requests include proper authentication headers:
- `Authorization: Bearer {JWT_TOKEN}`
- `X-API-KEY: {X_API_KEY}`

## Security Features

- **Secure Storage**: Credentials are encrypted using Flutter Secure Storage
- **No Hardcoded Secrets**: All sensitive data loaded from external configuration
- **HTTPS Only**: All API communications use HTTPS
- **Permission Management**: Proper camera and microphone permission handling

## Workflow

1. **Permission Setup** → Application requests camera/microphone permissions
2. **Configuration Loading** → Secure credentials loaded from encrypted storage
3. **Acuant SDK Initialization** → WebView loads with Acuant JavaScript SDK
4. **Document Capture** → User captures ID document using Acuant Camera SDK
5. **Initiate Verification** → Front document image sent to IdCloud KYC API (`POST /scenarios`)
6. **Additional Images** → Back/IR/UV images sent if needed (`PATCH /scenarios/{id}/state/steps/{type}`)
7. **Face Verification** → User performs liveness detection using Acuant PassiveLiveness
8. **Get Results** → Verification results retrieved (`PATCH /scenarios/{id}/state/steps/verifyResults`)
9. **Status Monitoring** → Real-time scenario status checks (`GET /scenarios/{id}`)
10. **Completion** → Complete document verification workflow

## Usage Flow

1. **Launch App**: Grant camera and microphone permissions
2. **Start Verification**: App initializes and becomes ready for document capture
3. **Capture Document**: Use "Capture Document" to take photos of ID documents (automatically initiates verification)
4. **Face Verification**: Use "Face Verification" for liveness detection
5. **Get Results**: Tap "Get Verification Results" to retrieve verification data from IdCloud
6. **Check Status**: Monitor verification progress with scenario status
7. **Complete**: Finalize the document verification process

## Troubleshooting

### Configuration Issues
- Ensure `config.json` exists and contains valid credentials
- Check that JWT token is not expired
- Verify X-API-KEY is correct

### Camera Issues
- Grant camera permissions in device settings
- Ensure device has a working camera
- Try manual capture if live capture fails

### API Issues
- Check internet connectivity
- Verify Gemalto API endpoint is accessible
- Check API credentials are valid
- Review logs for specific error messages

### WebView Issues
- Ensure WebView is updated on Android devices
- Clear app data if WebView appears corrupted
- Check console logs in debug mode

## Development Notes

### Adding New API Endpoints

1. Add method to `ApiService`
2. Add case in `WebViewScreen._handleApiCall()`
3. Update HTML JavaScript to call new endpoint

### Modifying UI

- Main UI is in the HTML file at `assets/web/index.html`
- Flutter UI is in `lib/screens/webview_screen.dart`
- Styling can be modified in the HTML CSS section

### Configuration Changes

- Update models in `lib/models/config_model.dart`
- Modify `ConfigService` to handle new configuration options
- Update example configuration file

## File Structure

```
lib/
├── models/
│   └── config_model.dart          # Configuration data models
├── services/
│   ├── config_service.dart        # Configuration management
│   └── api_service.dart          # Gemalto API integration
├── screens/
│   └── webview_screen.dart       # Main WebView interface
└── main.dart                     # Application entry point

assets/
└── web/
    ├── index.html                # Modified Acuant SDK interface
    └── webSdk/                   # Acuant SDK files

android/
└── app/src/main/
    ├── AndroidManifest.xml       # Android permissions
    └── kotlin/.../MainActivity.kt # Android activity

ios/
└── Runner/
    └── Info.plist               # iOS permissions and config
```

## Support

For issues related to:
- **Acuant SDK**: Refer to [Acuant documentation](https://github.com/Acuant/JavascriptWebSDKV11)
- **Gemalto API**: Contact your Gemalto representative
- **Flutter WebView**: Check [webview_flutter documentation](https://pub.dev/packages/webview_flutter)

## License

This project is subject to your organization's licensing terms. Ensure compliance with Acuant's EULA and Gemalto's terms of service.

----------------------------------------------------------
