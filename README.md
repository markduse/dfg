# Duse Financial Group — Website

Live at [dusefg.netlify.app](https://dusefg.netlify.app)

## Pages

| URL | Description |
|-----|-------------|
| `/` | Customer-facing homepage (DFG branded) |
| `/join` | Agent recruiting page (not indexed) |

## Setup

### Google Sheets Form Integration

1. Create a new Google Sheet
2. Go to **Extensions → Apps Script**
3. Paste the following code:

```javascript
function doPost(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var data = JSON.parse(e.postData.contents);
  sheet.appendRow([
    data.timestamp,
    data.firstName,
    data.lastName,
    data.email,
    data.phone || '',
    data.state,
    data.interest || data.licensed || '',
    data.goal || '',
    data.message,
    data.source
  ]);
  return ContentService.createTextOutput('OK');
}
```

4. Click **Deploy → New deployment → Web app**
5. Set "Who has access" to **Anyone**
6. Copy the Web App URL
7. Replace `YOUR_GOOGLE_APPS_SCRIPT_URL_HERE` in both `index.html` and `join/index.html`

## Assets

- `assets/dfg-logo.png` — DFG circular logo
- `assets/mark-headshot.png` — Mark Dusevic headshot

## Updates

All updates made via GitHub → auto-deploys to Netlify on push to `main`.
