# Habit Tracking Mobile App  

## Links  
- **Figma Design**: [https://www.figma.com/design/gONgrq8Q5PfEs1LUo7KX4h/Tracker?node-id=0-1]  

## Purpose and Goals  
The app helps users build good habits and track their progress.  

### App Goals:  
- Track habits by days of the week.  
- View habit progress.  

## Brief Description  
The app consists of habit tracker cards created by the user. Each card includes a name, category, and schedule. Users can also select an emoji and color to distinguish cards.  

Cards are sorted by category. Users can search for them and apply filters.  
A calendar allows users to see which habits are planned for a specific day.  

The app includes statistics showing the user’s progress, success metrics, and averages.  

## Functional Requirements  

### Onboarding  
When users open the app for the first time, they are taken to the onboarding screen.  

**The onboarding screen includes:**  
- Splash screen  
- Title and secondary text  
- Page controls  
- “Wow, technology!” button  

**Algorithms and Actions:**  
- Users can swipe left and right to switch between pages. Page controls update accordingly.  
- Pressing "Wow, technology!" takes users to the main screen.  

### Creating a Habit Card  
On the main screen, users can create a tracker for a habit or an irregular event.  
- **A habit** is an event that repeats with a set frequency.  
- **An irregular event** is not tied to specific days.  

#### **The habit tracker creation screen includes:**  
- Screen title  
- Input field for tracker name  
- Category section  
- Schedule settings section  
- Emoji selection  
- Tracker color selection  
- “Cancel” button  
- “Create” button  

#### **The irregular event tracker creation screen includes:**  
- Screen title  
- Input field for tracker name  
- Category section  
- Emoji selection  
- Tracker color selection  
- “Cancel” button  
- “Create” button  

**Algorithms and Actions:**  
- Users can create a tracker for either a habit or an irregular event. The process is similar, except the schedule section is missing in irregular events.  
- Users enter a tracker name (max **38 characters**).  
- After entering a single character, a clear button appears.  
- If the name exceeds the limit, an error message is shown.  
- Tapping "Category" opens the category selection screen.  
  - If no categories exist, a placeholder is shown.  
  - The last selected category is marked with a blue checkmark.  
  - Users can add a new category by tapping "Add category."  
  - Once a category is selected, it is displayed below the "Category" title.  
- In habit creation mode, users can set a schedule:  
  - Tapping "Schedule" opens a screen to select days of the week.  
  - Selected days appear below the "Schedule" title.  
  - If all days are selected, it displays “Every day.”  
- Users can select an emoji and a tracker color.  
- "Cancel" exits without saving.  
- "Create" is only enabled when all fields are filled.  

### Viewing the Main Screen  
On the main screen, users can view all created trackers, edit them, and see statistics.  

#### **The main screen includes:**  
- "+" button to add a habit  
- "Trackers" title  
- Current date  
- Search bar  
- Tracker cards sorted by category, each containing:  
  - Emoji  
  - Tracker name  
  - Tracked days count  
  - Completion button  
- "Filter" button  
- Tab bar  

**Algorithms and Actions:**  
- Pressing "+" opens a menu to create a habit or irregular event.  
- Pressing the date opens a calendar for habit tracking by date.  
- Users can search for trackers by name.  
- If no results are found, a placeholder appears.  
- Filters allow users to sort habits:  
  - **All trackers**: Displays all trackers for the selected day.  
  - **Today's trackers**: Shows only trackers planned for today.  
  - **Completed trackers**: Shows only completed habits.  
  - **Uncompleted trackers**: Shows habits that were not completed.  
- Users can scroll through the habit list.  
- If an image fails to load, a system loader appears.  
- Pressing a tracker blurs the background and opens a modal window.  
- Users can **pin** trackers, moving them to the **Pinned** category at the top.  
- Users can edit or delete a tracker.  
  - Deleting opens a confirmation window.  
  - If confirmed, all tracker data is removed.  

### Editing and Deleting Categories  
Users can edit or delete categories while creating a tracker.  

**Algorithms and Actions:**  
- Long press a category to open a modal window.  
- Pressing "Edit" allows users to rename the category.  
- Pressing "Delete" opens a confirmation window.  

### Viewing Statistics  
In the **Statistics** tab, users can track their progress and key metrics.  

#### **The Statistics screen includes:**  
- "Statistics" title  
- List of statistics, each with:  
  - Title and value  
  - Secondary text with the metric name  
- Tab bar  

**Algorithms and Actions:**  
- If no data is available, a placeholder is shown.  
- If data exists, the statistics are displayed:  
  - **"Best streak"**: Maximum consecutive days with completed habits.  
  - **"Perfect days"**: Days where all planned habits were completed.  
  - **"Trackers completed"**: Total completed habits.  
  - **"Average completion"**: Average number of completed habits per day.  

### Dark Mode  
The app supports dark mode, which follows the system settings.  

## Non-Functional Requirements  
- Supports iPhone X and later, including iPhone SE.  
- Minimum iOS version: **13.4**  
- Uses **SF Pro**, the default iOS font.  
- **Core Data** is used for storing habit data.  
