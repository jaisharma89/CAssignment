# CAssignment
CAssignment Project Details

How to run:

 As this app have Camera functionality , please run it on the device . Connect your device to mac using USB cable and complete code signing process. Follow the below steps
   1. Select your device as target to run
   2.  Select Product-> Run.
   3.  This will launch the app on Device.
   4. Select date and time to see the records

How to Run Tests
 Unit Tests can be run with or without Internet connection. Follow the below steps
 1. Select the device or Simulator as Target
 2. Select Product -> Test
 3.  on Left Side of Xcode Window , you can see the tests report of all the tests passed and failed
 

Assumptions : 
 1. If user Selected time is not listed in the room availability list it is assumed as not available
 2. As there is no date mentioned in room availability list , time listed  is considered for all the dates.
 3. Selecting the Level as sorting will display result in ascending order
 4. Selecting the Capacity will display result in descending order


Note: I’ve followed the MVVM pattern , all the application logic is in View model or Utility class for better testability and UI code is in View Controller class.

Please review the code and provide your feedback .

Regards,
Jai
