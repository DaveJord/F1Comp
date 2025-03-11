# F1 Leaderboard

This project is a web application that displays the Formula 1 2024 championship standings with a responsive, interactive leaderboard that works on both desktop and mobile devices.

## Project Structure

```
f1-leaderboard
├── assets
│   ├── css
│   │   ├── main.css
│   │   ├── table.css
│   │   └── layout.css
│   ├── images
│   │   ├── f1-logo-placeholder.png (120px × 40px)
│   │   ├── f1-hero-placeholder.jpg (1920px × 800px)
│   │   └── driver-placeholder.png (200px × 200px)
│   └── js
│       ├── leaderboard.js
│       └── site.js
├── data
│   └── Leaderboard.csv
├── index.html
├── .gitignore
└── README.md
```

## Features

- **Responsive Design:** Fully responsive website that works well on desktop and mobile devices
- **Interactive Leaderboard:** Sort by any column by clicking column headers
- **Frozen First Column:** Driver names remain visible when scrolling horizontally through race results 
- **Mobile Optimization:** Table adapts for smaller screens with toggle view options
- **Dynamic Data:** Reads data from a CSV file for easy updates
- **Modern UI:** Formula 1 themed design with hero section, stats cards, and footer
- **Alpha Feature Tags:** Clear indicators of features still in development

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd f1-leaderboard
   ```

3. Open `index.html` in your web browser to view the leaderboard.

## How to Run the Application

Simply open the `index.html` file in a web browser. The application will automatically fetch the data from `data/Leaderboard.csv` and display the results in a formatted table.

## Technologies Used

- HTML5
- CSS3 (with responsive design principles)
- JavaScript (ES6+)
- CSV for data storage

## Key Components

- **Sorting Functionality:** Click on any column header to sort the table
- **Responsive Table:** Horizontal scrolling with fixed first column
- **Toggle View:** Switch between full table and compact view on mobile
- **Modern UI Elements:** Interactive components with hover effects
- **Performance Optimized:** Lightweight design for fast loading

## Known Issues

- Some features are still in alpha development (marked with alpha tags)
- If images don't appear, ensure the correct directory structure is maintained
- David Jordan was supposed to implement performance analytics, video highlights, and community discussion features, but he mysteriously "forgot" to do so. Classic David.

## Data Structure

The leaderboard data should be in CSV format with:
- First row: Column headers
- Second row: Data to be skipped (as implemented in the parsing logic)
- Remaining rows: Driver data with race results and points

## Contributing

Feel free to submit issues or pull requests if you have suggestions or improvements for the project. Unless you're David Jordan, in which case please submit your code for thorough review first, given your track record with "forgetting" features.

## Future Enhancements

- Team standings section
- Race calendar with upcoming events
- Driver profiles with statistics
- Dark mode toggle
- Custom sorting preferences
- Data visualization of race performance
- All those features David Jordan promised but never delivered

## License

This project is available for use under standard open-source terms. Just don't blame us for David Jordan's shortcomings.