# 🚀 Manual Deployment Guide - Real Estate System

## Quick Deploy to Your Salesforce Org

Since the automated deployment isn't working, let's deploy the Real Estate system manually. This will show you both approaches!

### Method 1: Using Salesforce CLI (Recommended)

**Step 1: Open PowerShell in your project directory**
```bash
cd "C:\Users\Kaleem Azam\Desktop\Salesforce Dev Workflow 16 june 2025\SalesforceDevWorkflow"
```

**Step 2: Authenticate to your org**
```bash
sf org login web --alias MyOrg
```
- This will open your browser
- Log into your Salesforce org: https://cloudseek-dev-ed.develop.lightning.force.com
- Authorize the CLI

**Step 3: Deploy the Property object first**
```bash
sf project deploy start --source-dir "force-app/main/default/objects/Property__c" --target-org MyOrg
```

**Step 4: Deploy the Client object**
```bash
sf project deploy start --source-dir "force-app/main/default/objects/Client__c" --target-org MyOrg
```

**Step 5: Deploy the Apex classes**
```bash
sf project deploy start --source-dir "force-app/main/default/classes" --target-org MyOrg
```

**Step 6: Deploy the tabs**
```bash
sf project deploy start --source-dir "force-app/main/default/tabs" --target-org MyOrg
```

### Method 2: Manual Creation in Salesforce (If CLI doesn't work)

**Step 1: Create Property Object**
1. Go to Setup → Object Manager → Create → Custom Object
2. Fill out:
   - Label: Property
   - Plural Label: Properties
   - Object Name: Property__c
3. Click Save

**Step 2: Add Property Fields**
Go to the Property object → Fields & Relationships → New for each:

1. **Address** (Text, 255, Required)
2. **Price** (Currency, Required)
3. **Bedrooms** (Number, 2 digits, 0 decimal)
4. **Bathrooms** (Number, 3 digits, 1 decimal)
5. **Square Feet** (Number, 8 digits, 0 decimal)
6. **Listing Date** (Date)
7. **Description** (Long Text Area, 32768)
8. **Property Type** (Picklist):
   - House
   - Apartment
   - Condo
   - Townhouse
   - Commercial
   - Land
9. **Status** (Picklist, Required):
   - Available (default)
   - Under Contract
   - Sold
   - Off Market
   - Pending
10. **Listing Agent** (Lookup to User)

**Step 3: Create Client Object**
1. Setup → Object Manager → Create → Custom Object
2. Fill out:
   - Label: Client
   - Plural Label: Clients
   - Object Name: Client__c
3. Add fields:
   - **Email** (Email, Unique)
   - **Phone** (Phone)
   - **Client Type** (Picklist): Buyer, Seller, Both, Lead

**Step 4: Create Validation Rules**
Property object → Validation Rules → New:

1. **Price Must Be Positive**
   - Rule Name: Price_Must_Be_Positive
   - Formula: Price__c <= 0
   - Error Message: "Property price must be greater than $0"

**Step 5: Create Tabs**
1. Setup → Tabs → Custom Object Tabs → New
2. Create tab for Property__c (Building icon)
3. Create tab for Client__c (People icon)

### Method 3: Use Workbench (Web-based deployment)

**Step 1: Go to Workbench**
1. Visit: https://workbench.developerforce.com/
2. Login with your Salesforce credentials

**Step 2: Deploy Metadata**
1. Go to Migration → Deploy
2. Upload a ZIP file containing our metadata
3. Check "Single Package"
4. Click "Deploy"

## Verification Steps

After deployment, verify everything works:

**Step 1: Check Objects**
1. Go to Setup → Object Manager
2. You should see "Property" and "Client" objects

**Step 2: Check Tabs**
1. Click App Launcher (9 dots)
2. You should see "Properties" and "Clients" tabs

**Step 3: Test Creating Records**
1. Click Properties tab → New
2. Fill out a sample property
3. Save and verify it works

**Step 4: Test Validation**
1. Try to create a property with $0 price
2. You should get an error message

## Troubleshooting

**If you get permission errors:**
- Make sure you're logged in as System Administrator
- Check that your user has "Modify All Data" permission

**If objects don't appear:**
- Refresh your browser
- Check Setup → Object Manager to confirm deployment

**If tabs don't show:**
- Go to Setup → Apps → App Manager
- Edit your app and add the new tabs

## Quick Test Script

Once deployed, test with this sample data:

**Property 1:**
- Name: Luxury Downtown Condo
- Address: 123 Main Street
- Price: $750,000
- Property Type: Condo
- Status: Available
- Bedrooms: 2
- Bathrooms: 2.5
- Square Feet: 1800

**Client 1:**
- Name: John Smith
- Email: john.smith@email.com
- Phone: (555) 123-4567
- Client Type: Buyer

## Success Indicators

✅ You can create Property records
✅ You can create Client records  
✅ Validation rules prevent bad data
✅ Tabs appear in your app
✅ Fields display correctly

Once this is working, you'll have a complete Real Estate Management System in your Salesforce org!

## Next Steps

After manual deployment:
1. Test all functionality
2. Create sample data
3. Explore the automation features
4. Ask Cursor AI to add more features

The manual approach shows you exactly what the CI/CD pipeline does automatically - but the pipeline is 100x faster and safer! 