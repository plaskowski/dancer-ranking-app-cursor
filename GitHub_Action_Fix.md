# GitHub Action Fix - Release Workflow Failure

## Issue Summary
The release workflow failed with a "Resource not accessible by integration" error, which is a permissions-related issue preventing the workflow from performing write operations on your repository.

## Root Cause
The workflow requires **write permissions** to:
- Commit version changes to `pubspec.yaml`
- Push changes to the `main` branch
- Create and push git tags
- Create GitHub releases with APK artifacts

## 🚀 Quick Fix (Recommended)

### Step 1: Update Repository Workflow Permissions

1. **Go to your repository on GitHub**
   - Navigate to: `https://github.com/plaskowski/dancer-ranking-app-cursor`

2. **Access Settings**
   - Click the **Settings** tab (you must be a repository owner/admin)
   - Navigate to **Actions** → **General**

3. **Update Workflow Permissions**
   - Scroll down to the **"Workflow permissions"** section
   - Change from **"Read repository contents permission"** 
   - To **"Read and write permissions"**
   - ✅ Check **"Allow GitHub Actions to create and approve pull requests"**
   - Click **Save**

### Step 2: Re-run the Failed Workflow

1. **Go to Actions tab**
   - Click **Actions** tab in your repository
   - Find the failed workflow run
   - Click **Re-run all jobs**

OR

2. **Start a new release**
   - Click **Actions** tab
   - Find **Release Build and Deploy** workflow
   - Click **Run workflow**
   - Select your desired release type (patch/minor/major)
   - Click **Run workflow**

## 🔧 Alternative Solutions

### Option A: Verify Current Permissions
First, check if the permissions are already correct:

```bash
# Check current repository settings via GitHub CLI (if you have it)
gh repo view plaskowski/dancer-ranking-app-cursor --json defaultBranchRef,pushedAt
```

### Option B: Use Personal Access Token (if organization policies prevent changes)

1. **Create a Personal Access Token**
   - Go to GitHub Settings → Developer settings → Personal access tokens
   - Generate a new token with `repo` scope
   - Copy the token

2. **Add as Repository Secret**
   - Repository Settings → Secrets and variables → Actions
   - Add new secret named `RELEASE_TOKEN`
   - Paste your token

3. **Update workflow** (I can do this if needed)

## 🔍 Verification Steps

After applying the fix, verify it works:

1. **Check workflow logs**
   - Look for successful completion of all steps
   - Verify no "Resource not accessible" errors

2. **Verify outputs**
   - New version tag created
   - GitHub release created with APK
   - `pubspec.yaml` updated with new version

## 📋 What the Workflow Does

Your release workflow performs these operations:
- ✅ Merges `first-line` and `second-line` branches into `main`
- ✅ Bumps version in `pubspec.yaml`
- ✅ Builds Flutter APK for Android
- ✅ Commits version changes
- ✅ Creates and pushes git tags
- ✅ Creates GitHub releases with APK artifacts

## 🚨 Important Notes

1. **Repository Owner Required**: Only repository owners can change workflow permissions
2. **Organization Policies**: If this is an organization repo, check org-level permissions
3. **Branch Protection**: Ensure `main` branch protection allows GitHub Actions to push

## 💡 Next Steps

1. **Apply the fix** using Step 1 above
2. **Test the workflow** by running it manually
3. **Monitor future releases** to ensure the fix works consistently

## 🔗 Additional Resources

- [GitHub Actions Permissions Documentation](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#permissions)
- [Repository Settings for Actions](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository)

---

**Status**: Ready to fix - follow Step 1 above to resolve the permissions issue.