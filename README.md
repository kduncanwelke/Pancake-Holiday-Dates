# Pancake Holiday Dates
Fun holiday calendar

This app uses data from the [Abstract API](https://app.abstractapi.com) Holidays service to show holidays for the U.S. on a simple monthly calendar view. For an element of whimsy, the app employes a character - pancake kitty - as a mascot and to mark calendar dates that have a holiday. The user can tap on one of these dates to view a pop up that lists brief details summarizing the holiday(s) for that day.

<img src="https://i.ibb.co/GnvnHhh/Simulator-Screen-Shot-i-Phone-11-2021-10-17-at-14-36-33.png" width="25%"/>

## Features

This app accesses the Abstract API and parses JSON containing details for a holiday for a given date. Since this app retrieves data under the free plan, which rate limits API calls to one per second and only allows calls to a specific day (rather than a whole month), the app iterates through each day of the month, retrieving holiday information for a day, then executing a one second delay before running the next API request. Retrieved data is placed into a dictionary with a date key so it can be accessed easily.

As the rate limit means data loads require some time, calendar cells are refreshed as holiday data comes in - if a day has holiday(s) its cell is refreshed so it can display live feedback. An activity indicator and message indicate that the load is in progress, and to further abate user impatience, a pancake kitty that the user can squish with a long press is displayed at the bottom of the screen. This allows the user a chance to be amused while the API requests are made.

By tapping a calendar day with a holiday, as marked by the presence of the pancake kitty, a user can view the information for holidays for that day. Some days have more than one holiday, so holiday information - name, type, and country - is displayed in a small pop-up table view. If a day does not have a holiday, this view will not show up. Additionally, it must be dismissed in order to select a new day (as it overlays the calendar physically).

To navigate to another month, the user can either use the left and right arrows at the top of the screen to go backwards or forward by one month, or they can use the dropdown arrow next to month and year label to select a new month and year to jump to. To help prevent partial data loads of a currently displayed month, which would create incomplete data that would require redundant reloads, a user must wait for the current month to load before navigating to a new one.

To handle loss of network, or errors in the connection, the app uses a Network Monitor to check the connection status before executing an API request. If the request fails due to lack of connection, or loss of connection partway through, the app fails gracefully and displays a network loss message and a reload button. This button will be displayed if data was already loaded as well, allowing for the possibility of an incomplete load to be re-queried so data can be completed. This case could occur if network was lost partway through a series of requests for a month, then the user navigated away from that month.

An additional warning is in place if the API delivers an API limit error, which will notify the user if the current API key's total possible requests allocation has been used up. This case will employ some of the same strategies as network loss to provide feedback to the user, in addition to this special notice.

Behind the scenes a MVVM design pattern handles splitting responsibility between models (for holding onto data), a view model (one in this case, for delivering information to the view), and a view (for users to interact with). The models hold the information for the calendar and holidays, while the view model performs all 'thinking' functions and gives the view the information it needs to display. Calendar information is acquired using calculations based off of the native calendar function. 

## Art
Art of a pancake kitty is included as an integral part of this app, primarily to demarcate calendar days that have a holiday. This art was created by myself (the developer) and belongs to no one else.

## Support
If you experience trouble using the app, have any questions, or simply want to contact me, you can contact me via email at kduncanwelke@gmail.com. I will be happy to discuss this project.
