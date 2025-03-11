document.addEventListener('DOMContentLoaded', function() {
    fetch('data/Leaderboard.csv')
        .then(response => response.text())
        .then(data => {
            const parsedData = parseCSV(data);
            let currentSortColumn = 'Total'; // Default sort column
            let currentSortDirection = 'desc'; // Default sort direction
            
            // Initial table generation with default sort
            generateTable(parsedData, currentSortColumn, currentSortDirection);
            
            // Add event listeners for sortable column headers
            setupSortableColumns(parsedData, currentSortColumn, currentSortDirection);
        })
        .catch(error => console.error('Error fetching the CSV file:', error));
});

function parseCSV(data) {
    const rows = data.split('\n');
    
    // Skip first data row (assuming row 0 is headers, row 1 is the line you want to skip)
    const headerRow = rows[0].split(',').map(header => removeQuotes(header.trim()));
    
    // Start from row 1 (index 1) to skip the header row and first data row
    const results = rows.slice(1).map(row => {
        if (!row.trim()) return null; // Skip empty rows
        
        const rowData = row.split(',');
        const result = {};
        
        headerRow.forEach((header, index) => {
            // Apply removeQuotes to each cell value
            result[header] = removeQuotes(rowData[index]?.trim() || '');
        });
        return result;
    }).filter(row => row !== null); // Remove any null entries from empty rows
    
    return results;
}

// Helper function to remove quotes from CSV values
function removeQuotes(value) {
    if (typeof value !== 'string') return value;
    
    // Remove both double and single quotes if they wrap the entire string
    if ((value.startsWith('"') && value.endsWith('"')) || 
        (value.startsWith("'") && value.endsWith("'"))) {
        return value.substring(1, value.length - 1);
    }
    return value;
}

function generateTable(data, sortColumn = 'Total', sortDirection = 'desc') {
    // Make sure we have data before trying to generate the table
    if (!data || data.length === 0) {
        console.error('No data to display');
        return;
    }
    
    // Sort the data
    const sortedData = sortData(data, sortColumn, sortDirection);
    
    const tableBody = document.querySelector('#leaderboard tbody');
    if (!tableBody) {
        console.error('#leaderboard tbody element not found');
        return;
    }
    
    // Clear existing content
    tableBody.innerHTML = '';
    
    // Add rows
    sortedData.forEach(row => {
        const tr = document.createElement('tr');
        Object.values(row).forEach(value => {
            const td = document.createElement('td');
            td.textContent = value || '-'; // Display '-' for empty values
            tr.appendChild(td);
        });
        tableBody.appendChild(tr);
    });
}

function setupSortableColumns(data, initialSortColumn, initialSortDirection) {
    const headers = document.querySelectorAll('#leaderboard thead th');
    let currentSortColumn = initialSortColumn;
    let currentSortDirection = initialSortDirection;
    
    // Add sort indicators to headers
    headers.forEach(header => {
        // Create sort indicator element
        const sortIndicator = document.createElement('span');
        sortIndicator.classList.add('sort-indicator');
        header.appendChild(sortIndicator);
        
        // Set initial sort indicator on the default sort column
        if (header.textContent.trim() === currentSortColumn) {
            header.classList.add('sorted');
            header.classList.add(currentSortDirection === 'asc' ? 'asc' : 'desc');
        }
        
        // Add click event to headers
        header.addEventListener('click', () => {
            const columnName = header.textContent.trim();
            
            // If clicking the same column, toggle sort direction
            if (columnName === currentSortColumn) {
                currentSortDirection = currentSortDirection === 'asc' ? 'desc' : 'asc';
            } else {
                // If clicking a different column, set it as current and use default direction
                currentSortColumn = columnName;
                // For numerical columns (like points) default to desc, otherwise asc
                if (columnName === 'Points' || columnName === 'Total' || 
                    /^[A-Z]{3}$/.test(columnName)) { // Race columns (3 letters)
                    currentSortDirection = 'desc';
                } else {
                    currentSortDirection = 'asc';
                }
            }
            
            // Update sort indicators
            headers.forEach(h => {
                h.classList.remove('sorted', 'asc', 'desc');
            });
            
            header.classList.add('sorted');
            header.classList.add(currentSortDirection);
            
            // Regenerate table with new sort
            generateTable(data, currentSortColumn, currentSortDirection);
        });
    });
}

function sortData(data, column, direction) {
    return [...data].sort((a, b) => {
        let valueA = a[column] || '';
        let valueB = b[column] || '';
        
        // For numeric columns, convert to numbers for proper sorting
        if (column === 'Points' || column === 'Total' || /^[A-Z]{3}$/.test(column)) {
            valueA = parseFloat(valueA) || 0;
            valueB = parseFloat(valueB) || 0;
        } else {
            // Case-insensitive string comparison for text columns
            valueA = String(valueA).toLowerCase();
            valueB = String(valueB).toLowerCase();
        }
        
        if (valueA < valueB) {
            return direction === 'asc' ? -1 : 1;
        }
        if (valueA > valueB) {
            return direction === 'asc' ? 1 : -1;
        }
        return 0;
    });
}