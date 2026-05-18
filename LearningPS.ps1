#PowerShell Learning

##############################comparison operator###################################################

2 -eq 2 #eual to
2 -gt 1 #greater then
2 -ne 3 #not equal to
2 -ge 2 #geater then, qual to
2 -lt 3 #less then
2 -le 2 #less then, qual to


##########################arrays ( hold multiple items ) #########################################

$a = 1,2,3,4,5,"Hello"
$a.GetType()
$a.Count
$a | ForEach-Object {$_.GetType()}


#let say you have to print a single number from the array; note index in array always start from 0.

$a[0] #print the first index of array
$a[0 .. 3] #print the index from 0 to 3

# ( .. ) is called range operator and you can use it in your array also like:

$arrayb = 1 .. 10
$arrayb
$arrayb[0 .. 4]
$arrayb[-2 .. -4]    #Get result in reverse 


###############################################ForEacg Looping Construct################################################

<# In PowerShell, when you see something like `foreach ($i in $collection)`, the `$i` is just a **temporary variable** used to represent **each item** in the collection as the loop runs.

 What `foreach ($i in $collection)` Means

Let’s say you have:
```powershell
$numbers = 1, 2, 3, 4, 5
foreach ($i in $numbers) {
    Write-Output $i
}
```

Here’s what happens:
- `$numbers` is a collection (an array of numbers).
- `foreach` loops through each item in `$numbers`.
- `$i` takes on the value of each item **one at a time**.
- So the loop prints: `1`, `2`, `3`, `4`, `5`

### Why Use `$i`?

- `$i` is short for “index” or “item”—but you can name it anything!
- It’s just a placeholder for the current element in the loop.
- You can use it to perform actions on each item, like calculations, filtering, or formatting.

### Example with Custom Variable Name

```powershell
$fruits = "Apple", "Banana", "Cherry"
foreach ($fruit in $fruits) {
    Write-Output "I like $fruit"
}
```

Output:
```
I like Apple
I like Banana
I like Cherry
```

So `$i` isn’t special—it’s just a convention. You could use `$item`, `$value`, `$obj`, or even `$x` if you like.

Want to try writing a loop together? Or maybe explore how to use `ForEach-Object` for pipeline operations? I’ve got plenty of tricks up my sleeve.


PowerShell expects either:

foreach (...) { ... } — keyword style

ForEach-Object { ... } — pipeline style



Use $_ when working with pipelines.

Use custom variables like $i when using foreach loops for clarity and control.

#>

$services = Get-service | Select-Object -Property Name
ForEach ($service in $services)
{
$service
}



$counting = 1 .. 10
ForEach ($num in $counting)
{
$num*2
}


$counting = 1 .. 10
ForEach ($i in $counting)
{
$_*2
}


$counting = 1 .. 10
$counting | ForEach-Object {$_.GetType()}




######################################hashtable#####################################


$settings = @{
"AppName" = "App1" #Key + Value
"Version" = "1.0.0"
"Maxusers" = 100
}

$settings["appname", "Version"] 

#note that whenever you want to get an information from a collection (array) alwasy use [], And to get 
# Information from a hashtable you need to mention 'key' as showing in e.g. above. If you want to get multiple values from a hashtable then you need to mention multiple keys as showing in e.g. above.


$userDetails = @{
"UserName" = "Mohit"
"Age" = 26
"Department" = "IT"

}

$userDetails["Country"] = "India" #Add / Update a key/value
$userDetails["Age"] = 27 #Add / Update a key/value
$userDetails.Remove("Department") #Remove a key+value pair
$userDetails.Count 
$userDetails.Keys
$userDetails.Values


#################loop through hastable###################################

ForEach ($i in $userDetails)
{
$i
}


ForEach ($i in $userDetails)
{
$i.Keys
}

ForEach ($i in $userDetails)
{
$i.Values
}

ForEach ($i in $userDetails.Keys)
{
$i
}

ForEach ($i in $userDetails.Keys)
{
$userDetails[$i]
}

$userDetails.Containe("UserName") #check the key / value is availale in a hashtable or not. for value use ".ContainsValue"
$userdetails.GetHashCode() #get the hash code of a hashtable
$userDetails.GetEnumerator() #get the enumerator of a hashtable
$userDetails.ToString() #get the string representation of a hashtable
$userDetails.GetType() #get the type of a hashtable


#################Custom Object#############################

#What is the difference between hashtable and custom object?
#A hashtable is a collection of key-value pairs, while a custom object is an instance of a class that can have properties and methods. 
#A hashtable is typically used for storing and retrieving data based on keys, while a custom object can represent more complex data structures and behaviors.


$login = [PSCustomObject]@{
    FirstName = "Mohit"
    LastName  = "Panwar"
    Age       = 26
    Country   = "India" 
}
$login.Country #access a property of custom object; In custom object we use . (dot) to access a property
#but in hashtable we use ["key", "key"] (square brackets) to access a value.
#in array we use [index] (square brackets) to access a value.


"Full Name: $($login.FirstName) $($login.LastName) is from $($login.Country)" #String Interpolation

#####################How to create list of custom object###########

$users = @(
    [PSCustomObject]@{FirstName = "Mohit"; LastName  = "Panwar"; Age       = 26; Country   = "India" }
    [PSCustomObject]@{FirstName = "John"; LastName  = "Doe"; Age       = 30; Country   = "USA" }
    [PSCustomObject]@{FirstName = "Jane"; LastName  = "Smith"; Age       = 28; Country   = "UK" }
    
)
$users[2].FirstName

############################loop through list of custom object###########################

#Interate throught a list of custom objects

foreach ($i in $users){
    "$($i.FirstName) $($i.lastname)"
}



<############################# Pipeline ( Very Important Concept in PowerShell ) ###############################
Output of one command as input of another command
Command 1 | Command 2 | Command 3 
#>

#E.g. 1
"Hello world" | ForEach-Object {$_. ToUpper()}
#E.g. 2
Get-Process | Where-Object {$_.CPU -gt 100} | Select-Object -Property Name, CPU | Sort-Object -Property CPU -Descending
#E.g. 3
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object Name, Status
#E.g. 4
Get-ChildItem C:\Windows\System32 | Where-Object {$_.Length -gt 100MB} | Select-Object Name, Length

<# PowerShell Function

function Get-WelcomeMessage {
    Write-Host "Hello! Welcome to PowerShell scripting." -ForegroundColor Cyan
}

Get-WelcomeMessage #This will call the function and display the welcome message in cyan color.

Function is a reusable block of code that performs a specific task. It allows you to encapsulate logic and reuse it throughout your script 
or even across multiple scripts. Functions can take parameters, perform operations, and return values.
You should you it when you have a block of code that you want to reuse multiple times in your script or across different scripts. 
Functions help improve code organization, readability, and maintainability by allowing you to break down complex tasks into smaller, manageable pieces. They also promote code reusability, as you can call the same function with different parameters to achieve different results without duplicating code.

why function not custom object or hashtable? because function is designed to perform a specific task or set of tasks, while custom objects and hashtables are primarily used for storing and organizing data.
Functions allow you to encapsulate logic and behavior, making it easier to reuse code and perform operations on data, whereas custom objects and hashtables 
are more focused on representing and managing data structures.

below is a simple example of a PowerShell function that takes two parameters and returns their sum:

function Add-Numbers {
    param (
        [int]$a,
        [int]$b
    )
    return $a + $b
}


#You can call this function like this:
Add-Numbers -a 5 -b 10 #This will return 15, which is the sum of 5 and 10. 



key components of a function:
1. Function Name: The name of the function, which is used to call it. In the example above, the function name is `Add-Numbers`.
2. Parameters: The inputs that the function accepts. In the example, the function takes two parameters, `$a` and `$b`, which are both of type `int` (integer).
3. Function Body: The block of code that defines what the function does. In the example, the function body contains a single line that returns the sum of `$a` and `$b`.
4. Return Value: The output that the function produces. In the example, the function returns the result of adding `$a` and `$b`.
5. Function Definition: The entire block of code that defines the function, including the function name, parameters, and body. In the example, 
the function definition starts with `function Add-Numbers {` and ends with `}`.

What are parameters in PowerShell functions?
Parameters in PowerShell functions are variables that are defined within the function and are used to accept input values when the function is called. 
They allow you to pass data into the function, which can then be used within the function's body to perform operations or calculations. 
Parameters are defined using the `param` keyword followed by a block of code that specifies the parameter names and their types.

Can we use parameter without defining it in the function?
No, you cannot use a parameter in a PowerShell function without defining it first. Parameters must be explicitly defined within the function using the `param` block. 
This allows the function to know what inputs it expects and how to handle them.


rules for naming parameters in PowerShell functions:
1. Parameter names must be unique within a function.
2. Parameter names should be descriptive and meaningful to indicate their purpose.
3. Parameter names should not contain spaces or special characters. Use camelCase or PascalCase for readability.
4. Parameter names should not start with a number or contain reserved keywords.
5. Parameter names should be consistent with PowerShell naming conventions, such as using verbs for function names and nouns for parameter names.
6. Parameter names should be concise but informative, avoiding unnecessary abbreviations or overly long names.
7. Parameter names should be case-insensitive, but it is recommended to follow a consistent casing style for readability.
8. Parameter names should not conflict with existing cmdlet parameters or common variable names to avoid confusion.


structured approach to writing parameters in PowerShell functions:
1. Define the function name using the `function` keyword followed by a descriptive name.   
2. Use the `param` block to define the parameters that the function will accept. Each parameter should have a name and a type declaration.
3. Inside the function body, use the parameters to perform the desired operations or calculations.
4. Use the `return` statement to specify the output of the function, if necessary.
5. Optionally, include error handling within the function to manage exceptions or invalid input.

below is a simple example of understanding parameters in PowerShell functions:
function Get-Greeting {
    param (
        [string]$Name
    )
    return "Hello, $Name!"
}

#>

Function Get-Greeting {
    param (
        [string]$Name
    )
    return "Hello, $Name!"
}
Get-Greeting -Name "Mohit" #This will return "Hello, Mohit!" as the output.


<# 

PowerShell functions are blocks of reusable code that you can build to automate repetitive tasks. Think of them as custom commands that you design, test once, and run whenever you need them.

Here is a step-by-step breakdown to take you from a complete beginner to building advanced, production-grade PowerShell tools.

---

## 1. Beginner Level: The Basic Function

At its simplest, a function consists of the `function` keyword, a name, and a script block `{}` containing the code you want to run.

### Syntax & Example

```powershell
function Get-WelcomeMessage {
    Write-Host "Hello! Welcome to PowerShell scripting." -ForegroundColor Cyan
}

```

### How to Run It

Once you load the function into your PowerShell session, you call it just like a native command:

```powershell
Get-WelcomeMessage

```

### Best Practice: Verb-Noun Naming

Always name your functions using PowerShell’s standard **Verb-Noun** convention (e.g., `Get-Process`, `New-Item`). Use `Get-Verb` in your console to see an approved list of verbs (like `Get`, `Set`, `New`, `Remove`, `Test`).

---

## 2. Intermediate Level: Adding Parameters and Output

Static functions are limited. To make them dynamic, you accept input using **parameters** and return data using the `return` keyword or by simply placing the object in the pipeline.

### Adding Parameters

You define parameters inside a `param()` block at the top of your function.

```powershell
function New-UserGreeting {
    param(
        $UserName,
        $Role = "Guest" # You can set a default value
    )

    return "Hello $UserName, you are logged in as a $Role."
}

```

### How to Run It

You can pass arguments by position or explicitly by parameter name:

```powershell
# Using parameter names (Recommended for readability)
New-UserGreeting -UserName "Suraj" -Role "Administrator"

# Relying on default value
New-UserGreeting -UserName "Alex"

```

---

## 3. Advanced Level: "Advanced Functions" (Cmdlet Binding)

To make your functions behave exactly like native, robust PowerShell cmdlets, you turn them into **Advanced Functions**. You do this by adding the `[CmdletBinding()]` attribute right above your parameter block.

This unlocks powerful enterprise features:

* **Built-in parameters** like `-Verbose`, `-Debug`, `-ErrorAction`.
* **Parameter Validation** (ensuring input data is correct before the code runs).
* **Pipeline Support** (processing data passed from other commands).

### The Advanced Template

Here is what a production-ready advanced function looks like:

```powershell
function Get-ServerStatus {
    [CmdletBinding()]
    param(
        # 1. Make this parameter mandatory
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName,

        # 2. Restrict inputs to a specific list
        [ValidateSet("Ping", "Service", "All")]
        [string]$CheckType = "Ping"
    )

    begin {
        # Runs ONCE at the start of the function execution
        Write-Verbose "Initializing network checks..."
    }

    process {
        # Runs ONCE FOR EACH object passed through the pipeline
        Write-Verbose "Checking status for: $ComputerName using method: $CheckType"
        
        if ($CheckType -eq "Ping") {
            if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
                [PSCustomObject]@{
                    ComputerName = $ComputerName
                    Online       = $true
                    Timestamp    = (Get-Date)
                }
            } else {
                [PSCustomObject]@{
                    ComputerName = $ComputerName
                    Online       = $false
                    Timestamp    = (Get-Date)
                }
            }
        }
    }

    end {
        # Runs ONCE after all pipeline objects are processed
        Write-Verbose "All checks completed."
    }
}

```

### Why the `begin`, `process`, and `end` blocks matter:

If you pipe a list of 100 computer names into this function:

* The `begin` block runs **1 time**.
* The `process` block loops and runs **100 times** (using the automatic variable `$_` or `$ComputerName` to represent the current item).
* The `end` block runs **1 time**.

### How to Run an Advanced Function

Now you can leverage `-Verbose` to see your background tracking messages, or pipe arrays directly into it:

```powershell
# Running with verbose logging
Get-ServerStatus -ComputerName "Localhost" -Verbose

# Running via the Pipeline
"Server01", "Server02", "Server03" | Get-ServerStatus -CheckType Ping

```

---

## 4. Expert Concepts: Error Handling and Safety

When writing advanced scripts, you must anticipate failures (e.g., a server is offline, access is denied).

### 1. Try/Catch Blocks

Wrap risky commands inside a `try` block and handle errors cleanly in a `catch` block.

```powershell
try {
    Stop-Service -Name "Spooler" -ErrorAction Stop
} catch {
    Write-Error "Failed to stop service. Reason: $_"
}

```

*(Note: You must use `-ErrorAction Stop` to force a non-terminating error to trigger the `catch` block).*

### 2. Supporting `-WhatIf` and `-Confirm`

If your function changes system states (like deleting files or restarting servers), protect your environment by enabling impact safety checks inside `[CmdletBinding()]`.

```powershell
function Remove-OldLogFiles {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [string]$Path
    )

    # This checks if the user ran the command with -WhatIf
    if ($PSCmdlet.ShouldProcess($Path, "Delete log files older than 30 days")) {
        # Your actual deletion logic goes here
        Remove-Item -Path $Path
    }
}

```

If someone runs `Remove-OldLogFiles -Path "C:\Logs" -WhatIf`, PowerShell will safely simulate what *would* have happened without changing anything.

---

Which specific piece of this progression would you like to drill down into next—parameter validation tricks, handling the pipeline, or organizing these into reusable script modules?

#>