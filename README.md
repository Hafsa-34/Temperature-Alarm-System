Temperature Alarm System (8086 Assembly Language)
📋 Description
The Temperature Alarm System is a simple interactive 8086 assembly program designed to monitor temperature input and provide visual/audio alerts based on the temperature level. 
It supports both Celsius and Fahrenheit inputs and indicates temperature status via text color simulation (representing LEDs) and an audible beep for critical levels.
The project mimics real-world hardware feedback using BIOS interrupts and EMU8086 macros/functions for educational simulation purposes.

💻 Features
1. Accepts temperature input in either Celsius or Fahrenheit
2. Converts Fahrenheit to Celsius internally
3. Compares input temperature with defined threshold
4. Displays messages based on comparison results:
🔵 Too Low (Blue LED)
🟢 Below Threshold (Green LED)
🟡 At Threshold (Yellow LED)
🔴 Above Threshold + 🔊 Buzzer (Red LED with beep)
5. Offers a restart option after each run
6. Exits gracefully with a thank-you message

🛠 Technical Details
🔢 Threshold & Conversion
Threshold: 50°C
Conversion Formula:
Celsius = (Fahrenheit - 32) * 5 / 9

📊 Message Indicators
Status	Condition	Color	Alert Type
1. Too Low	Temp < 15°C	Blue	Blue LED
2. Below Threshold	15°C ≤ Temp < 50°C	Green	Green LED
3. At Threshold	Temp == 50°C	Yellow	Yellow LED
4. Above Threshold	Temp > 50°C	Red	Red LED + Beep

🧠 Code Logic
Start Menu: Ask the user to choose input type (C/F)
Input Handling:
1. For Celsius: directly stores input
2. For Fahrenheit: converts to Celsius
3. Comparison: Based on threshold (50°C), displays appropriate message and LED simulation
4. Restart/Exit: User can repeat the process or terminate the program

📥 I/O Methods
1. INT 21H: For displaying strings and receiving input
2. INT 10H: To simulate LED color changes via text attribute manipulation
3. Beep Sound: Using BIOS teletype with ASCII Bell (07H)

🔄 Flow Summary
START
 └─► Choose Unit (C/F)
      ├─► If C → Input temp in Celsius
      └─► If F → Input temp in Fahrenheit → Convert to Celsius

 └─► Compare temperature with threshold
      ├─► < 15 → Blue LED
      ├─► < 50 → Green LED
      ├─► == 50 → Yellow LED
      └─► > 50 → Red LED + Buzzer

 └─► Ask to continue
      ├─► Yes → Restart
      └─► No → End Program
      
📎 Requirements
1. EMU8086 (or compatible 8086 assembler/emulator)
2. 16-bit DOS environment (real or emulated)

🔚 End Message
When exiting, the user is shown:
**THANK YOU FOR USING THE HEATER ALARM SYSTEM.
PROGRAM TERMINATED SUCCESSFULLY.**
