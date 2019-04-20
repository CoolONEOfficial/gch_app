const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.countlikechange = functions.database.ref('/tasks/{postid}/votes').onUpdate(
    async (change) => {
        const collectionRef = change.after.ref.parent;
        const countRef = collectionRef.parent.child('likes_count');

        let increment;
        if (change.after.exists() && !change.before.exists()) {
            increment = 1;
        } else if (!change.after.exists() && change.before.exists()) {
            increment = -1;
        } else {
            return null;
        }

        await countRef.transaction((current) => {
            return (current || 0) + increment;
        });
        console.log('Counter updated.');
        return null;
    });
