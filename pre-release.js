// npx semantic-release -e ./pre-release.js

module.exports = {
  dryRun: true,
  npmPublish: false,
  generateNotes: [ "@semantic-release/release-notes-generator" ],
  verifyRelease: [
    [ "@semantic-release/exec", { verifyReleaseCmd: "./bump.sh ${nextRelease.version}" } ]
  ],
};
