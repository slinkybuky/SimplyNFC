# iOS Build Workflows for SideStore & TrollStore

This document explains how to use the GitHub workflows to build your SimplyNFC app into `.ipa` and `.tipa` files for distribution on SideStore and TrollStore.

## Workflows Overview

### 1. **build-ios-app.yml** (Unsigned Build)
- **Trigger**: Automatically runs on push to main/master/develop and pull requests
- **No signing required** ✅ Perfect for SideStore/TrollStore
- **Outputs**: 
  - `.ipa` files (Artifact: `SimplyNFC-ipa`)
  - `.tipa` files (Artifact: `SimplyNFC-tipa`)

### 2. **build-ios-app-signed.yml** (Signed Build)
- **Trigger**: Manual dispatch (workflow_dispatch)
- **Requires signing certificate** (optional)
- **Outputs**: Signed `.ipa` file

## Quick Start

### Option 1: Unsigned Build (Recommended for SideStore/TrollStore)

1. Push a commit to your repository:
   ```bash
   git push origin master
   ```

2. Go to GitHub → Actions → Select "Build iOS App"

3. Wait for the workflow to complete (~5-10 minutes)

4. Download artifacts:
   - Click on the workflow run
   - Scroll to "Artifacts" section
   - Download `SimplyNFC-ipa` or `SimplyNFC-tipa`

5. **For SideStore**: 
   - Download the `.ipa` file
   - Use SideStore app to install it

6. **For TrollStore**:
   - Download the `.tipa` file
   - Use TrollStore app to install it
   - (Alternatively, you can use the `.ipa` file with TrollStore's drag-and-drop feature)

### Option 2: Manual Trigger

1. Go to GitHub → Actions → "Build iOS App"
2. Click "Run workflow" dropdown
3. Select your branch and click "Run workflow"

### Option 3: Release Builds

Create a GitHub release to automatically attach built .ipa files:

```bash
git tag v1.0.0
git push origin v1.0.0
```

The workflow will automatically create a release with the built artifacts.

## Configuration

### Customize Build Settings

Edit the workflow file and update these values:

**In `.github/workflows/build-ios-app.yml`:**

```yaml
- name: Build for iOS
  run: |
    xcodebuild \
      -scheme SimplyNFC \  # Change if your app has a different scheme
      -configuration Release \
      -archivePath build/SimplyNFC.xcarchive \
      archive
```

### Change Bundle Identifier (if needed)

1. Open `SimplyNFC.xcodeproj` in Xcode
2. Select the app target
3. Go to Build Settings → Signing & Capabilities
4. Update Bundle Identifier (if you need a custom one)
5. Commit and push

## Setting Up Signed Builds (Optional)

If you want to sign the app with a certificate:

### Step 1: Prepare Certificate and Provisioning Profile

1. Create a signing certificate on Apple Developer portal
2. Download the `.p12` certificate file
3. Create/download a provisioning profile (`.mobileprovision`)

### Step 2: Encode Files for GitHub Secrets

Run these commands locally:

```bash
# For certificate
base64 -i path/to/certificate.p12 | pbcopy

# For provisioning profile
base64 -i path/to/profile.mobileprovision | pbcopy
```

### Step 3: Add GitHub Secrets

1. Go to GitHub Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add the following secrets:
   - `BUILD_CERTIFICATE_BASE64` - Paste the encoded .p12 file
   - `P12_PASSWORD` - Your certificate password
   - `BUILD_PROVISION_PROFILE_BASE64` - Paste the encoded .mobileprovision file
   - `KEYCHAIN_PASSWORD` - Any secure password for temporary keychain

### Step 4: Run Signed Build

1. Go to GitHub Actions → "Build iOS App (Signed)"
2. Click "Run workflow"
3. Download the signed `.ipa`

## Understanding .IPA vs .TIPA

### .IPA (iOS App Package)
- Standard iOS app format
- Works with SideStore ✅
- Works with TrollStore ✅
- No special requirements

### .TIPA (TrollStore IPA)
- Modified format for TrollStore
- Only works with TrollStore
- Requires TrollStore app to be installed
- May have additional capabilities on jailbroken devices

## Troubleshooting

### Build fails with "scheme not found"

**Solution**: 
1. Open `SimplyNFC.xcodeproj` in Xcode
2. Product → Scheme → Manage Schemes
3. Note the correct scheme name
4. Update the workflow file with the correct scheme name

### "No provisioning profile found" error

**Solution**: Use the unsigned build workflow instead (it doesn't require provisioning profiles)

### .ipa file not created in artifacts

**Solution**:
1. Check the workflow logs for error messages
2. Ensure the Xcode project builds successfully locally first
3. Try manually triggering the workflow from GitHub Actions

### Import certificate fails with "Keychain error"

**Solution**:
1. Re-encode your certificate: `base64 -i certificate.p12 | pbcopy`
2. Update the GitHub secret with the new encoded value
3. Make sure P12_PASSWORD is correct

## macOS Runners

The workflows use `macos-latest` which is currently macOS 13 or 14 with Xcode 15.x.

To use a specific macOS version, edit the workflow:

```yaml
runs-on: macos-13  # or macos-14, macos-15
```

## Downloading via curl (if needed)

You can also automate downloading artifacts via GitHub API:

```bash
# List artifacts
gh run list -R yanngodeau/SimplyNFC --limit 1 --json artifacts

# Download specific artifact
gh run download <RUN_ID> -R yanngodeau/SimplyNFC -n SimplyNFC-ipa
```

## Security Notes

- Secrets are encrypted and never logged in workflows
- Certificates are deleted after each workflow run
- GitHub Actions has official support for code signing
- For production apps, consider using Fastlane for advanced signing options

## Next Steps

1. ✅ Add workflows to your repo
2. ✅ Push a commit to trigger the first build
3. ✅ Download the .ipa/.tipa files
4. ✅ Test with SideStore or TrollStore
5. ✅ (Optional) Set up signed builds if needed

## References

- [GitHub Actions for iOS](https://github.com/marketplace?type=actions&query=iOS)
- [SideStore Documentation](https://sidestore.io)
- [TrollStore Documentation](https://trollstore.io)
- [Apple Code Signing Guide](https://developer.apple.com/support/code-signing/)
