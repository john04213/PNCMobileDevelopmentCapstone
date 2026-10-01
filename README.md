# PNCMobileDevelopmentCapstone



1
Requirement: Secure sign-in and session management
Requirements Specifications: Employees need to sign in with credentials recognized by the AdventureWorks service. After successful authentication, the application must preserve the authorized session appropriately, attach the access token to protected requests, and provide a clear sign-out action. Invalid credentials and expired sessions must be handled without exposing secrets or technical details.
Assignee: John Hernandez
Priority: Critical

2
Requirement: Operational dashboard
Requirements Specifications: Managers need a concise overview of current operations. The experience should make weekly sales, strong and weak product performance, low-stock products, and employee shift information easy to scan. The team must decide which information deserves the most prominence and how users move from a summary to supporting detail.
Assignee: Harris Riley
Priority: Medium

3
Requirement: Employee directory and profile
Requirements Specifications: Users need to browse employees and open a useful profile for a selected employee. The list should help users distinguish people with similar names and should expose relevant department, title, shift, hire-date, or employment-history information when available.
Assignee: Harris Riley
Priority: High

4
Requirement: Search, sort, or filter
Requirements Specifications: Users should not have to scan a long list to find a record. Provide at least two meaningful discovery controls within one or more major areas, such as partial-name search, department filtering, low-stock filtering, date-based sorting, or price sorting. The interface must make the active criteria apparent and allow them to be cleared.
Assignee: John Hernandez
Priority: Medium

5
Requirement: Product catalog and details
Requirements Specifications: Employees need to browse AdventureWorks products and inspect details for a selected product. Present business-relevant content such as product number, summary, price, color, warranty, model information, or image data when available. Missing optional data must not produce a broken layout.
Assignee: Miles Eidson
Priority: High

6
Requirement: Inventory awareness
Requirements Specifications: Operations staff need to see product quantities by location and identify stock that is at or below its reorder point. Users must be able to understand which product, location, shelf/bin, current quantity, and threshold are involved without mentally correlating separate screens.
Assignee: Daniela Chavez
Priority: High

7
Requirement: Order exploration
Requirements Specifications: Users need to review orders and inspect line-level detail. The application must support at least one order audience—individual customers or stores—and clearly present order identity, customer/store context, dates, products, quantities, prices, and totals.
Assignee: Miles Eidson
Priority: Medium

8
Requirement: Refresh and current-state feedback
Requirements Specifications: Users need a deliberate way to request information refresh in at least two data-driven areas. The interface must distinguish initial loading, user-initiated refresh, successfully loaded content, an empty result, and a failed request. Repeated taps or navigation must not create confusing duplicate work.
Assignee: Daniela Chavez
Priority: Medium

9
Requirement: Failure recovery and partial availability
Requirements Specifications: A failed request must not crash the app or leave an endless progress indicator. The user should receive a plain-language explanation and a reasonable recovery action. Failure in one feature area should not unnecessarily block unrelated areas that can still operate.
Assignee: John Hernandez
Priority: Low

10
Requirement: Accessible and adaptable interface
Requirements Specifications: Core tasks must be usable with Dynamic Type and VoiceOver. Interactive elements need meaningful labels and adequate touch targets, information cannot depend on color alone, and key screens must remain usable across supported iPhone sizes and orientations selected by the team.
Assignee: Daniela Chavez
Priority: Low

11
Requirement: Authorized Inventory Adjustment
Requirements Specifications: Operations staff may need to correct a product quantity at a specific location. Provide a guarded editing flow that shows the existing value, validates the proposed quantity, requires review or confirmation, sends the supported update, and clearly communicates success or failure.
Assignee: Miles Eidson
Priority: Medium

12
Requirement: Token renewal
Requirements Specifications: Users with a valid refresh token should not be forced to sign in again solely because the access token expires. The application should attempt one safe renewal and retry the interrupted request. If renewal fails, it must return the user to a secure signed-out state without creating an infinite retry loop.
Assignee: Harris Riley
Priority: Medium


