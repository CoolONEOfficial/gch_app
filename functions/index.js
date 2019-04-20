const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.countlikechange = functions.database.ref('/tasks/').onUpdate(
    async (change, context) => {
        // Only edit data when it is first created.
        if (change.before.exists()) {
            return null;
        }
        // Exit when the data is deleted.
        if (!change.after.exists()) {
            return null;
        }
        // Grab the current value of what was written to the Realtime Database.
        const original = change.after.val();
        console.log('blahblah ', context.params.pushId, original);

        return null;
    });
