.MODEL SMALL
.STACK 100H

.DATA
; ---- Login Messages ----
welcomeMsg  DB 13,10, '=== Welcome to Restaurant System ===',13,10,'$'
signInMsg   DB 13,10, 'Enter your ID: $'
successMsg  DB 13,10, 'Login Successful!',13,10,'$'
failMsg     DB 13,10, 'Invalid ID. Access Denied.',13,10,'$'
userTypeMsg DB 13,10, 'Login As:',13,10
            DB '1. Customer',13,10
            DB '2. Admin',13,10
            DB 'Enter choice (1-2): $'

; ---- Admin Messages ----
adminWelcomeMsg DB 13,10, '=== ADMIN MODE ACTIVATED ===',13,10,'$'
adminMenuMsg DB 13,10, 'Admin Options:',13,10
             DB '1. View Customer Reviews',13,10
             DB '2. Continue to Restaurant System',13,10
             DB '3. Exit',13,10
             DB 'Enter your choice: $'
reviewsTitle DB 13,10, '=== CUSTOMER REVIEWS ===',13,10,'$'
reviewsFooter DB 13,10, '=== END OF REVIEWS ===',13,10,'$'
noReviewsMsg DB 13,10, 'No reviews available yet.',13,10,'$'

; ---- Review Storage ----
MAX_REVIEWS DB 10                  ; Maximum number of reviews to store
reviewCount DB 0                   ; Current number of reviews
reviewRatings DB 10 DUP(0)         ; Array to store ratings (1-5)
reviewComments DB 10 DUP(50 DUP('$')) ; Array to store comments (10 reviews, 50 chars each)
reviewRatingMsg DB 'Rating: $'
reviewCommentMsg DB 'Comment: $'

; ---- Valid User IDs (null-terminated) ----
userIDs     DB 'admin1234', 0
            DB 'user0001', 0
            DB 'user0002', 0
inputID     DB 11 DUP('$') ; up to 10 chars + null
isAdmin     DB 0 ; Flag to track if current user is admin
userType    DB 0 ; 1 for customer, 2 for admin

; ---- Restaurant Messages ----
mtitle       db 13,10,'--- Welcome to Assembly Restaurant ---$'
menu1        db 13,10,'1. Italian Cuisine$'
menu2        db 13,10,'2. Indian Cuisine$'
menu3        db 13,10,'3. Chinese Cuisine$' 
menu4        db 13,10,'4. Check your Calories$'
selectMenu   db 13,10,'Select Cuisine (1-4): $'  ; Fixed range to include option 4
selectDish   db 13,10,'Select Dish (1-3): $'
addMore      db 13,10,'Order more? (Y/N): $'
thankYou     db 13,10,'Thank you for ordering!$'
orderedItems db 13,10,'Ordered Dishes: $'

; ------------------ Foreign Exchange ---------------
forex db 13,10, 'Would you like to convert the currency (Y/N): $' 
calorie db 13,10, 'Wanna see how much calorie the food has (Y/N): $'
msg_press_any_key db 13,10,'Press any key to continue...', 0Dh, 0Ah, '$'

; Foreign Exchange Calculator Messages and Variables
msg_forex_menu db 13,10,'===== Foreign Exchange Calculator =====', 0Dh, 0Ah
    db '1. USD to BDT', 0Dh, 0Ah
    db '2. BDT to USD', 0Dh, 0Ah
    db '3. Back to Restaurant Menu', 0Dh, 0Ah
    db 'Enter your choice: $'
msg_enter_amount db 13,10,'Enter amount (max 4 digits): $'
msg_result db 13,10,'Result: $'
msg_overflow db 13,10,'Error: Amount too large!$'

old_int0_offset dw ?
old_int0_segment dw ?

; Forex variables 
amount_buffer db 6, ?, 6 dup('$')
conversion_choice db 0    
temp dw 0
temp2 dw 0
ten dw 10
exchange_rate dw 110      


msg_divide_error db 13,10,'Division Error! Please try a smaller amount.$'

; ------------------Calorie Calculator ----------------
calorie_title DB 13,10,'===== Calorie Calculator =====', 0Dh, 0Ah, '$'
THANK_YOU_MSG DB '                              ********THANK YOU********$'  
PROMPT_CONTINUE DB '  Press any key to continue. $'  

ask2 DB "Please provide the following information:$"
ask3 DB "    Input Age: $"
ask4 DB "    Input Gender (M/F): $ " 
ask5 DB "    Input your Activity Routine from below: $ "
ask_height DB "    Input your height in cm: $"
ask_weight DB "    Input your weight in kg: $"

activity1 DB "        1. Sedentary (little or no exercise)$"
activity2 DB "        2. Lightly active (light exercise 1-3 days/week)$"
activity3 DB "        3. Moderately active (moderate exercise 3-5 days/week)$"
activity4 DB "        4. Very active (hard exercise 6-7 days/week)$"
activity5 DB "        5. Super active (very hard exercise/physical job)$"

string DB "    Your required daily calorie based on your Age, Gender and Activity is: $"

TRANSFER_HEIGHT DW ?
TRANSFER_WEIGHT DW ?     

AGE DW ?
GENDER DW ? 
ACTIVE DW ? 

BMR_RESULT DW ?

const1 DW 8836 
const2 DW 1339   
const3 DW 4799    
const4 DW 5677  

constf1 DW 4476
constf2 DW 9247
constf3 DW 3098
constf4 DW 4330

scale_factor DW 1000

;---------------Calorie Part ended--------------

; ---- Italian Dishes ----
italian1     db 13,10,'1. Pizza        - 100 Tk$'
italian2     db 13,10,'2. Pasta        - 80 Tk$'
italian3     db 13,10,'3. Lasagna      - 120 Tk$'

; ---- Indian Dishes ----
indian1      db 13,10,'1. Biryani      - 90 Tk$'
indian2      db 13,10,'2. Butter Chick.- 110 Tk$'
indian3      db 13,10,'3. Paneer Curry - 100 Tk$'

; ---- Chinese Dishes ----
chinese1     db 13,10,'1. Chow Mein    - 70 Tk$'
chinese2     db 13,10,'2. Fried Rice   - 60 Tk$'
chinese3     db 13,10,'3. Dumplings    - 80 Tk$'

; ---- Order System ----
orderList    db 10 dup(0)
orderPtr     db 0
total        dw 0

; ---- Discount System ----
askBarcaFan  db 13,10,'Are you a Barcelona fan? (Y/N): $'
discountMsg  db 13,10,'Congratulations!!10% Discount Applied! Visca EL Barca!$'
billMsg      db 13,10,'Total Bill: $'
tkMsg        db ' Tk$'  

; ---- Feedback Messages ----
fbPrompt        DB 13,10, 'Please rate us (1-5): $'
ratingReceived  DB 13,10, 'You rated: $'
commentPrompt   DB 13,10, 'Leave a short comment: $'
commentThanks   DB 13,10, 'Thanks for your feedback!$'
commentBuffer   DB 50 DUP('$')

changeOrderPrompt DB 13,10, 'Do you want to change your order? (Y/N): $'
returnToMenuMsg DB 13,10, 'Returning to main menu...$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    
    mov ax, 0
    mov es, ax
    mov ax, es:[0]
    mov old_int0_offset, ax
    mov ax, es:[2]
    mov old_int0_segment, ax
    
    cli
    mov word ptr es:[0], offset divide_error_handler
    mov word ptr es:[2], cs
    sti
welcome:
    ; Show welcome
    LEA DX, welcomeMsg
    CALL printStr
    
    ; Ask for user type
    LEA DX, userTypeMsg
    CALL printStr
    CALL readChar
    SUB AL, '0'
    MOV userType, AL
    
    ; Ask user for ID
    LEA DX, signInMsg
    CALL printStr

    ; Get input
    LEA DI, inputID
    CALL ReadString
    
    ; Check if admin login
    CMP userType, 2
    JNE regular_login
    
    ; Admin login - only check against admin1234
    LEA DI, inputID
    LEA SI, userIDs    ; First ID in the list is admin1234
    CALL CompareStrings
    CMP AL, 1
    JNE login_failed
    
    ; Admin login successful
    MOV isAdmin, 1
    LEA DX, successMsg
    CALL printStr
    
    ; Show admin welcome message
    LEA DX, adminWelcomeMsg
    CALL printStr
    JMP admin_menu
    
regular_login:
    ; Regular user login - check against all IDs
    MOV SI, OFFSET userIDs
    MOV CX, 3

CheckLoop:
    PUSH CX
    PUSH SI
    LEA DI, inputID
    CALL CompareStrings
    CMP AL, 1
    JE LoginSuccess
    POP SI
    POP CX
    CALL SkipToNextID
    LOOP CheckLoop
    
login_failed:
    ; If no match found
    LEA DX, failMsg
    CALL printStr
    JMP Exit

LoginSuccess:
    POP SI
    POP CX
    LEA DX, successMsg
    CALL printStr
    MOV isAdmin, 0
    JMP orderLoop

admin_menu:
    ; Display admin menu
    LEA DX, adminMenuMsg
    CALL printStr
    
    ; Get admin choice
    CALL readChar
    SUB AL, '0'
    
    CMP AL, 1
    JE show_customer_reviews
    CMP AL, 2
    JE orderLoop
    CMP AL, 3
    JE Exit
    
    ; Invalid choice, show menu again
    JMP admin_menu

show_customer_reviews:
    CALL display_customer_reviews
    JMP admin_menu

orderLoop:
    ; Display main menu
    LEA DX, mtitle
    CALL printStr
    LEA DX, menu1
    CALL printStr
    LEA DX, menu2
    CALL printStr
    LEA DX, menu3
    CALL printStr
    LEA DX, menu4
    CALL printStr

    ; Get cuisine choice
    LEA DX, selectMenu
    CALL printStr
    CALL readChar
    SUB AL, '0'
    MOV BL, AL

    ; Show selected menu
    CMP BL, 1
    JE italianMenu
    CMP BL, 2
    JE indianMenu
    CMP BL, 3
    JE chineseMenu 
    CMP BL, 4
    JE calorie_calculator
    CMP BL,5
    JMP Exit

italianMenu:
    LEA DX, italian1
    CALL printStr
    LEA DX, italian2
    CALL printStr
    LEA DX, italian3
    CALL printStr
    JMP askDish

indianMenu:
    LEA DX, indian1
    CALL printStr
    LEA DX, indian2
    CALL printStr
    LEA DX, indian3
    CALL printStr
    JMP askDish

chineseMenu:
    LEA DX, chinese1
    CALL printStr
    LEA DX, chinese2
    CALL printStr
    LEA DX, chinese3
    CALL printStr

askDish:
    LEA DX, selectDish
    CALL printStr
    CALL readChar
    SUB AL, '0'
    MOV BH, AL

    CMP BL, 1
    JE italianDishCode
    CMP BL, 2
    JE indianDishCode
    CMP BL, 3
    JE chineseDishCode
    JMP Exit

italianDishCode:
    MOV AL, BH
    ADD AL, 10
    MOV CL, AL
    CALL addToTotal
    JMP storeOrder

indianDishCode:
    MOV AL, BH
    ADD AL, 13
    MOV CL, AL
    CALL addToTotal
    JMP storeOrder

chineseDishCode:
    MOV AL, BH
    ADD AL, 16
    MOV CL, AL
    CALL addToTotal
    JMP storeOrder

storeOrder:
    MOV AL, orderPtr
    MOV AH, 0
    MOV SI, AX
    MOV orderList[SI], CL
    INC orderPtr

    LEA DX, addMore
    CALL printStr
    CALL readChar
    CMP AL, 'Y'
    JE orderLoop
    CMP AL, 'y'
    JE orderLoop

    LEA DX, thankYou
    CALL printStr
    LEA DX, orderedItems
    CALL printStr

    MOV SI, 0
    MOV CX, 0 
    MOV CL, orderPtr

printOrderLoop:
    CMP SI, CX
    JGE askChangeOrder
    MOV AL, orderList[SI]
    CALL printDish
    INC SI
    JMP printOrderLoop

askChangeOrder:
    LEA DX, changeOrderPrompt
    CALL printStr
    CALL readChar
    CMP AL, 'Y'
    JE resetOrder
    CMP AL, 'y'
    JE resetOrder
    JMP askForDiscount

resetOrder:
    ; Clear order and total
    MOV orderPtr, 0
    MOV total, 0
    ; Clear orderList
    MOV CX, 10
    MOV SI, 0
clearLoop:
    MOV orderList[SI], 0
    INC SI
    LOOP clearLoop
    JMP orderLoop

askForDiscount:
    LEA DX, askBarcaFan
    CALL printStr
    CALL readChar
    CMP AL, 'Y'
    JE applyDiscount
    CMP AL, 'y'
    JE applyDiscount
    JMP printTotal

applyDiscount:
    LEA DX, discountMsg
    CALL printStr
    MOV AX, total
    MOV BX, 10
    MUL BX
    MOV BX, 100
    DIV BX
    SUB total, AX

printTotal:
    LEA DX, billMsg
    CALL printStr
    MOV AX, total
    CALL printNumber
    LEA DX, tkMsg
    CALL printStr 
    
    
    JMP ask_forex
    
ask_forex:
    
    LEA DX, forex
    CALL printStr
    CALL readChar
    
    
    CMP AL, 'Y'
    JE call_forex_calculator
    CMP AL, 'y'
    JE call_forex_calculator
    
    
    JMP feedback_section
    
call_forex_calculator:
    
    CALL NEXT_LINE
    CALL forex_calculator
    
feedback_section:
    
    LEA DX, fbPrompt
    CALL printStr
    CALL readChar
    SUB AL, '0'
    
    ; Store the rating
    PUSH AX  
    
    LEA DX, ratingReceived
    CALL printStr
    MOV AH, 02H
    ADD AL, '0'
    MOV DL, AL
    INT 21H

    LEA DX, commentPrompt
    CALL printStr
    LEA DI, commentBuffer
    CALL ReadString

    LEA DX, commentThanks
    CALL printStr
    
    ; Store the review if we have space
    MOV AL, reviewCount
    CMP AL, MAX_REVIEWS
    JAE skip_review_storage  
    
    ; Store the rating
    POP AX  ; Retrieve the rating
    MOV BL, reviewCount
    XOR BH, BH
    MOV reviewRatings[BX], AL
    
    ; Store the comment - copy from commentBuffer to reviewComments
    MOV SI, OFFSET commentBuffer
    MOV AL, reviewCount
    MOV BL, 50  ; Each comment is 50 bytes
    MUL BL
    MOV DI, AX
    ADD DI, OFFSET reviewComments
    
    ; Copy the comment
    MOV CX, 50  ; Maximum comment length
copy_comment_loop:
    MOV AL, [SI]
    MOV [DI], AL
    INC SI
    INC DI
    CMP AL, 0   ; Check for null terminator
    JE end_comment_copy
    LOOP copy_comment_loop
    
end_comment_copy:
    ; Increment review count
    INC reviewCount
    JMP continue_after_review
    
skip_review_storage:
    POP AX  ; Clean up the stack
    
continue_after_review:
    ; Return to main menu
    CALL NEXT_LINE
    LEA DX, returnToMenuMsg
    CALL printStr
    CALL NEXT_LINE
    
    ; Wait for key press
    MOV AH, 1
    INT 21H
    
    ; If admin, go back to admin menu
    CMP isAdmin, 1
    JE admin_menu
    
    ; Otherwise, go back to order loop
    JMP welcome

Exit:
    ; Before exiting, restore old INT 0 vector
    cli
    mov ax, 0
    mov es, ax
    mov ax, old_int0_offset
    mov es:[0], ax
    mov ax, old_int0_segment
    mov es:[2], ax
    sti
    
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; ===== DISPLAY CUSTOMER REVIEWS 
display_customer_reviews PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI
    PUSH DI
    
    ; Display reviews title
    LEA DX, reviewsTitle
    CALL printStr
    
    ; Check if we have any reviews
    CMP reviewCount, 0
    JNE have_reviews
    
    ; No reviews yet
    LEA DX, noReviewsMsg
    CALL printStr
    JMP reviews_done
    
have_reviews:
    ; Initialize counters
    XOR CX, CX
    MOV CL, reviewCount
    XOR SI, SI  ; Review index
    
display_review_loop:
    ; Check if we've displayed all reviews
    CMP SI, CX
    JAE reviews_done
    
    ; Display review number
    CALL NEXT_LINE
    MOV AH, 02h
    MOV DL, '['
    INT 21h
    
    MOV AX, SI
    INC AX  ; 1-based display
    CALL printNumber
    
    MOV AH, 02h
    MOV DL, ']'
    INT 21h
    
    ; Display rating
    LEA DX, reviewRatingMsg
    CALL printStr
    
    MOV BL, reviewRatings[SI]
    ADD BL, '0'  ; Convert to ASCII
    MOV AH, 02h
    MOV DL, BL
    INT 21h
    
    ; Display comment
    CALL NEXT_LINE
    LEA DX, reviewCommentMsg
    CALL printStr
    
    ; Calculate comment offset
    MOV AX, SI
    MOV BL, 50  ; Each comment is 50 bytes
    MUL BL
    MOV DI, AX
    ADD DI, OFFSET reviewComments
    
    ; Display the comment
    MOV AH, 09h
    MOV DX, DI
    INT 21h
    
    CALL NEXT_LINE
    
    ; Move to next review
    INC SI
    JMP display_review_loop
    
reviews_done:
    ; Display footer
    CALL NEXT_LINE
    LEA DX, reviewsFooter
    CALL printStr
    
    ; Wait for key press
    LEA DX, msg_press_any_key
    CALL printStr
    CALL readChar
    
    POP DI
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX
    RET
display_customer_reviews ENDP



printStr PROC
    MOV AH, 09H
    INT 21H
    RET
printStr ENDP

readChar PROC
    MOV AH, 01H
    INT 21H
    RET
readChar ENDP

ReadString PROC
    MOV CX, 0
InputLoop:
    MOV AH, 01H
    INT 21H
    CMP AL, 13
    JE EndInput
    MOV [DI], AL
    INC DI
    INC CX
    CMP CX, 10
    JE EndInput
    JMP InputLoop
EndInput:
    MOV BYTE PTR [DI], 0
    RET
ReadString ENDP

CompareStrings PROC
    MOV AL, 0
CompareLoop:
    MOV BL, [SI]
    CMP BL, 0
    JE CheckInputEnd
    MOV BH, [DI]
    CMP BL, BH
    JNE NotEqual
    INC SI
    INC DI
    JMP CompareLoop
CheckInputEnd:
    CMP BYTE PTR [DI], 0
    JNE NotEqual
    MOV AL, 1
    RET
NotEqual:
    MOV AL, 0
    RET
CompareStrings ENDP

SkipToNextID PROC
NextChar:
    CMP BYTE PTR [SI], 0
    JE FoundEnd
    INC SI
    JMP NextChar
FoundEnd:
    INC SI
    RET
SkipToNextID ENDP

addToTotal PROC
    CMP CL, 11
    JE add100
    CMP CL, 12
    JE add80
    CMP CL, 13
    JE add120
    CMP CL, 14
    JE add90
    CMP CL, 15
    JE add110
    CMP CL, 16
    JE add100
    
    CMP CL, 17
    JE add70
    CMP CL, 18
    JE add60
    CMP CL, 19
    JE add80
    RET
add100:
    ADD total, 100
    RET
add80:
    ADD total, 80
    RET
add120:
    ADD total, 120
    RET
add90:
    ADD total, 90
    RET
add110:
    ADD total, 110
    RET
add70:
    ADD total, 70
    RET
add60:
    ADD total, 60
    RET
addToTotal ENDP

printNumber PROC
    MOV BX, 10
    XOR CX, CX

divideLoop:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE divideLoop

printLoop:
    POP DX
    ADD DL, '0'
    MOV AH, 02H
    INT 21H
    LOOP printLoop
    RET
printNumber ENDP

printDish PROC
    CMP AL, 11
    JE printItalian1
    CMP AL, 12
    JE printItalian2
    CMP AL, 13
    JE printItalian3
    CMP AL, 14
    JE printIndian1
    CMP AL, 15
    JE printIndian2
    CMP AL, 16
    JE printIndian3
    CMP AL, 17
    JE printChinese1
    CMP AL, 18
    JE printChinese2
    CMP AL, 19
    JE printChinese3
    RET

printItalian1:
    LEA DX, italian1
    CALL printStr
    RET
printItalian2:
    LEA DX, italian2
    CALL printStr
    RET
printItalian3:
    LEA DX, italian3
    CALL printStr
    RET
printIndian1:
    LEA DX, indian1
    CALL printStr
    RET
printIndian2:
    LEA DX, indian2
    CALL printStr
    RET
printIndian3:
    LEA DX, indian3
    CALL printStr
    RET
printChinese1:
    LEA DX, chinese1
    CALL printStr
    RET
printChinese2:
    LEA DX, chinese2
    CALL printStr
    RET
printChinese3:
    LEA DX, chinese3
    CALL printStr
    RET
printDish ENDP
    
;------------------ Calorie Calculator Part -----------------   
; Calorie Calculator
calorie_calculator:
    ; Display calorie calculator title
    LEA DX, calorie_title
    CALL printStr
    
    CALL NEXT_LINE
    
    ; Get user information
    LEA DX, ask2
    CALL printStr
    
    CALL NEXT_LINE
    
    ; Get height
    LEA DX, ask_height
    CALL printStr
    
    CALL INPUT_NUMBER
    MOV TRANSFER_HEIGHT, CX
    
    CALL NEXT_LINE
    
    ; Get weight
    LEA DX, ask_weight
    CALL printStr
    
    CALL INPUT_NUMBER
    MOV TRANSFER_WEIGHT, CX
    
    CALL NEXT_LINE
    
    ; Get age
    LEA DX, ask3
    CALL printStr
    
    CALL INPUT_NUMBER
    MOV AGE, CX
    
    CALL NEXT_LINE
    
    ; Get gender
    LEA DX, ask4
    CALL printStr
    
    CALL readChar
    
    ; Convert M/F to numeric value
    CMP AL, 'M'
    JE set_male
    CMP AL, 'm'
    JE set_male
    
    ; Default to female if not M
    MOV GENDER, 6
    JMP after_gender
    
set_male:
    MOV GENDER, 13
    
after_gender:
    CALL NEXT_LINE
    
    ; Get activity level
    LEA DX, ask5
    CALL printStr
    
    CALL NEXT_LINE
    LEA DX, activity1
    CALL printStr
    CALL NEXT_LINE
    
    LEA DX, activity2
    CALL printStr
    CALL NEXT_LINE
    
    LEA DX, activity3
    CALL printStr
    CALL NEXT_LINE
    
    LEA DX, activity4
    CALL printStr
    CALL NEXT_LINE
    
    LEA DX, activity5
    CALL printStr
    CALL NEXT_LINE
    
    CALL INPUT_NUMBER
    MOV ACTIVE, CX
    
    ; Calculate BMR based on gender
    MOV AX, GENDER
    CMP AX, 13
    JE CalorieCalculatorM
    JMP CalorieCalculatorF

; Male calorie calculation
CalorieCalculatorM:
    ; BMR Calculation for males
    MOV AX, TRANSFER_WEIGHT
    MOV BX, const2
    MUL BX            
    DIV scale_factor  
    MOV BX, AX        

    MOV AX, TRANSFER_HEIGHT
    MOV CX, const3
    MUL CX
    DIV scale_factor  
    ADD BX, AX        

    MOV AX, AGE
    MOV DX, const4
    MUL DX
    DIV scale_factor  
    SUB BX, AX        

    ADD BX, const1

    MOV BMR_RESULT, BX
    
    JMP calculate_activity

; Female calorie calculation
CalorieCalculatorF: 
    ; BMR Calculation for females
    MOV AX, TRANSFER_WEIGHT
    MOV BX, constf2
    MUL BX            
    DIV scale_factor  
    MOV BX, AX        

    MOV AX, TRANSFER_HEIGHT
    MOV CX, constf3
    MUL CX
    DIV scale_factor  
    ADD BX, AX        

    MOV AX, AGE
    MOV DX, constf4
    MUL DX
    DIV scale_factor  
    SUB BX, AX        

    ADD BX, constf1

    MOV BMR_RESULT, BX
    
    JMP calculate_activity

; Apply activity multiplier
calculate_activity:
    MOV AX, ACTIVE
    CMP AX, 1
    JE NoEx
    
    CMP AX, 2
    JE LightAct
    
    CMP AX, 3
    JE ModerateAct
    
    CMP AX, 4
    JE VeryAct
    
    CMP AX, 5
    JE SuperAct
    
    ; Default to NoEx if invalid
    JMP NoEx

; Activity level calculations
NoEx: 
    CALL NEXT_LINE 
    
    LEA DX, string
    CALL printStr
    
    MOV AX, BMR_RESULT
    MOV BX, 12
    MUL BX
    MOV CX, 10
    DIV CX 
   
    CALL PRINT_DIGIT
    JMP calorie_end
    
LightAct:  
    CALL NEXT_LINE  
    LEA DX, string
    CALL printStr
    
    MOV AX, BMR_RESULT

    CALL NEXT_LINE  
    LEA DX, string
    CALL printStr
    
    MOV AX, BMR_RESULT
    MOV BX, 1375
    MUL BX
    MOV CX, 1000
    DIV CX 
    
    CALL PRINT_DIGIT 
    JMP calorie_end
    
ModerateAct:
    CALL NEXT_LINE  
    LEA DX, string
    CALL printStr
    
    MOV AX, BMR_RESULT
    MOV BX, 155
    MUL BX
    MOV CX, 100
    DIV CX 
    
    CALL PRINT_DIGIT 
    JMP calorie_end
    
VeryAct: 
    CALL NEXT_LINE  
    LEA DX, string
    CALL printStr
    
    MOV AX, BMR_RESULT
    MOV BX, 1725
    MUL BX
    MOV CX, 1000
    DIV CX 
    
    CALL PRINT_DIGIT
    JMP calorie_end
    
SuperAct: 
    CALL NEXT_LINE  
    LEA DX, string
    CALL printStr
    
    MOV AX, BMR_RESULT
    MOV BX, 19
    MUL BX
    MOV CX, 10
    DIV CX 
    
    CALL PRINT_DIGIT
    JMP calorie_end

calorie_end:
    CALL NEXT_LINE
    CALL NEXT_LINE
    
    ; Thank you message
    LEA DX, PROMPT_CONTINUE
    CALL printStr
    
    CALL readChar
    
    CALL NEXT_LINE 
    
    LEA DX, THANK_YOU_MSG
    CALL printStr
    
    CALL NEXT_LINE
    CALL NEXT_LINE
    
    JMP orderLoop

; Forex Calculator
forex_calculator PROC
    LEA DX, msg_forex_menu
    CALL printStr

    ; Get user choice
    CALL readChar
    SUB AL, '0'
    
    ; Check for exit condition
    CMP AL, 3
    JE forex_exit    ; Return when user selects option 3
    
    ; Store choice properly
    MOV conversion_choice, AL    ; Store 1 for USD->BDT, 2 for BDT->USD
    
    CMP AL, 1
    JE get_amount
    CMP AL, 2
    JE get_amount
    JMP forex_calculator    ; Invalid choice, show menu again

get_amount:
    ; Get amount
    LEA DX, msg_enter_amount
    CALL printStr

    ; Read amount
    MOV AH, 0Ah
    LEA DX, amount_buffer
    INT 21h

    ; Convert string to number
    XOR AX, AX
    MOV CL, [amount_buffer+1]
    MOV CH, 0
    MOV SI, OFFSET amount_buffer + 2
    XOR BX, BX

convert_loop:
    MUL ten
    MOV BL, [SI]
    SUB BL, '0'
    ADD AX, BX
    INC SI
    LOOP convert_loop

    MOV temp, AX    ; Save input amount
    
    ; Check conversion type
    MOV AL, conversion_choice
    CMP AL, 1
    JE usd_to_bdt_conv
    JMP bdt_to_usd_conv

usd_to_bdt_conv:
    ; Convert USD to BDT (multiply by 110)
    MOV AX, temp        ; Get USD amount
    MOV BX, exchange_rate
    MUL BX              ; DX:AX = amount * 110
    
    ; Check for overflow
    CMP DX, 0
    JNE overflow_error
    
    MOV temp, AX       ; Store result
    XOR DX, DX         ; Clear DX for display
    JMP display_whole_result

bdt_to_usd_conv:
    ; Convert BDT to USD
    MOV AX, temp       ; Get BDT amount
    MOV DX, 0          ; Clear dx
    
    ; First divide by exchange rate (110) to avoid overflow
    MOV BX, exchange_rate
    DIV BX            ; AX = amount / 110, DX = remainder
    MOV temp, AX      ; Store whole number part
    
    ; Handle decimal part
    MOV AX, DX        ; Get remainder
    MOV DX, 0
    MOV BX, 100       ; Multiply remainder by 100 for 2 decimal places
    MUL BX            ; DX:AX = remainder * 100
    
    MOV BX, exchange_rate
    DIV BX            ; AX = decimal part
    
    MOV temp2, AX     ; Store decimal part
    JMP display_decimal_result

display_whole_result:
    ; For USD to BDT - show whole number only
    LEA DX, msg_result
    CALL printStr

    MOV AX, temp
    CALL printNumber
    JMP forex_end

display_decimal_result:
    ; For BDT to USD - show number with decimals
    LEA DX, msg_result
    CALL printStr

    ; Display whole number part
    MOV AX, temp
    CALL printNumber

    ; Display decimal point
    MOV DL, '.'
    MOV AH, 02h
    INT 21h

    ; Display decimal part with leading zeros if needed
    MOV AX, temp2
    CALL display_number_padded
    JMP forex_end

overflow_error:
    ; Display overflow error message
    LEA DX, msg_overflow
    CALL printStr
    JMP forex_end

forex_end:
    ; Print newline
    CALL NEXT_LINE
    CALL NEXT_LINE

    ; Wait for key press
    LEA DX, msg_press_any_key
    CALL printStr
    CALL readChar

forex_exit:
    RET
forex_calculator ENDP

; New line helper
NEXT_LINE PROC
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    MOV DL, 0AH
    INT 21H
    RET
NEXT_LINE ENDP

INPUT_NUMBER PROC
    MOV AX, 0
    MOV CX, 0
    
INPUT_LOOP:
    MOV AH, 1         
    INT 21H         
    CMP AL, 0DH       
    JE INPUT_DONE    
    
    AND AX, 000FH     
    PUSH AX          
    MOV AX, 10
    MUL CX           
    MOV CX, AX
    POP AX           
    ADD CX, AX       
    JMP INPUT_LOOP
    
INPUT_DONE:
    RET
INPUT_NUMBER ENDP

; Print number helper (for calorie calculator)
PRINT_DIGIT PROC
    XOR CX, CX
    MOV BX, 10
    
CONVERT_TO_STRING:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    TEST AX, AX
    JNZ CONVERT_TO_STRING
    
PRINT_LOOP:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP PRINT_LOOP
    RET
PRINT_DIGIT ENDP


divide_error_handler PROC
    PUSH AX
    PUSH DX
    
    MOV AX, @DATA
    MOV DS, AX
    
    ; Display error message
    LEA DX, msg_divide_error
    CALL printStr
    
    POP DX
    POP AX
    
    ; Jump back to forex calculator
    JMP forex_calculator
divide_error_handler ENDP


display_number_padded PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Always show two digits
    MOV BX, AX        ; Save number
    CMP AX, 10
    JAE no_leading_zero
    
    ; Show leading zero
    PUSH AX
    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    POP AX

no_leading_zero:
    MOV AX, BX
    CALL printNumber
    
    POP DX
    POP CX
    POP BX
    POP AX
    RET
display_number_padded ENDP

; Display number helper
display_number PROC
    CALL printNumber
    RET
display_number ENDP

END MAIN
