document.addEventListener('DOMContentLoaded', function() {
    // Mobile menu toggle
    const mobileMenuBtn = document.querySelector('.mobile-menu');
    const navLinks = document.querySelector('.nav-links');
    
    if (mobileMenuBtn) {
        mobileMenuBtn.addEventListener('click', function() {
            navLinks.classList.toggle('show');
        });
    }
    
    // Toggle view button
    const toggleViewBtn = document.getElementById('toggle-view');
    const leaderboardTable = document.getElementById('leaderboard');
    
    if (toggleViewBtn && leaderboardTable) {
        toggleViewBtn.addEventListener('click', function() {
            leaderboardTable.classList.toggle('compact-view');
            
            // Update button text
            const icon = toggleViewBtn.querySelector('i');
            if (leaderboardTable.classList.contains('compact-view')) {
                icon.classList.remove('fa-table');
                icon.classList.add('fa-list');
                
                // When in compact view, show only important columns
                const importantCols = ['Name', 'Points', 'Total']; // Add more if needed
                
                // Get column indices for columns we want to show
                const headers = Array.from(leaderboardTable.querySelectorAll('thead th'))
                    .map(th => th.textContent.trim());
                
                const showIndices = importantCols.map(col => headers.indexOf(col))
                    .filter(idx => idx !== -1);
                
                // Hide non-essential columns
                Array.from(leaderboardTable.querySelectorAll('tr')).forEach(row => {
                    Array.from(row.children).forEach((cell, idx) => {
                        if (!showIndices.includes(idx)) {
                            cell.style.display = 'none';
                        }
                    });
                });
            } else {
                icon.classList.remove('fa-list');
                icon.classList.add('fa-table');
                
                // Show all columns again
                leaderboardTable.querySelectorAll('th, td').forEach(cell => {
                    cell.style.display = '';
                });
            }
        });
    }
    
    // Add smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            
            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Update "last updated" with current date if it exists
    const lastUpdatedElement = document.getElementById('last-updated');
    if (lastUpdatedElement) {
        const now = new Date();
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        lastUpdatedElement.textContent = now.toLocaleDateString('en-US', options);
    }
    
    // Easter egg for David Jordan mentions
    const blameTags = document.querySelectorAll('.blame-tag');
    blameTags.forEach(tag => {
        tag.addEventListener('click', function() {
            alert("We've notified David Jordan about this missing feature. He said 'It's on the backlog!'");
        });
    });
});