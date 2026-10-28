const { readFileSync } = require('node:fs');
const { resolve } = require('node:path');
const { before, after, beforeEach, test } = require('node:test');
const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const { doc, setDoc, getDoc, updateDoc, collection, getDocs, query, where } = require('firebase/firestore');
let env;
before(async () => {
  env = await initializeTestEnvironment({projectId: 'demo-reading-stations',
    firestore: {rules: readFileSync(resolve(__dirname, '../firestore.rules'), 'utf8')}});
});
after(async () => { if (env) await env.cleanup(); });
beforeEach(async () => { await env.clearFirestore(); });
test('anonymous access is denied and only admin can create a station', async () => {
  const reader = env.authenticatedContext('reader').firestore();
  const admin = env.authenticatedContext('admin', {admin: true}).firestore();
  await assertFails(setDoc(doc(reader, 'stations/a'), {name: 'Station', location: 'Demo'}));
  await assertSucceeds(setDoc(doc(admin, 'stations/a'), {name: 'Station', location: 'Demo'}));
  await assertFails(getDoc(doc(env.unauthenticatedContext().firestore(), 'stations/a')));
  await assertSucceeds(getDoc(doc(reader, 'stations/a')));
});
test('profiles are private and cannot gain admin fields', async () => {
  const alice = env.authenticatedContext('alice', {email: 'alice@example.invalid'}).firestore();
  const bob = env.authenticatedContext('bob', {email: 'bob@example.invalid'}).firestore();
  await assertSucceeds(setDoc(doc(alice, 'users/alice'), {name: 'Alice', email: 'alice@example.invalid', favourites: []}));
  await assertFails(getDoc(doc(bob, 'users/alice')));
  await assertFails(updateDoc(doc(alice, 'users/alice'), {admin: true}));
  await assertFails(getDocs(collection(alice, 'users')));
});
test('readers query only owned requests and cannot resolve them', async () => {
  const alice = env.authenticatedContext('alice').firestore();
  const bob = env.authenticatedContext('bob').firestore();
  const admin = env.authenticatedContext('admin', {admin: true}).firestore();
  await assertSucceeds(setDoc(doc(alice, 'requests/a'), {userId: 'alice', title: 'A book', author: 'An author', type: 'missing', status: 'pending'}));
  await assertFails(getDoc(doc(bob, 'requests/a')));
  await assertFails(getDocs(collection(alice, 'requests')));
  await assertSucceeds(getDocs(query(collection(alice, 'requests'), where('userId', '==', 'alice'))));
  await assertFails(updateDoc(doc(alice, 'requests/a'), {status: 'resolved'}));
  await assertSucceeds(updateDoc(doc(admin, 'requests/a'), {status: 'resolved'}));
  await assertFails(updateDoc(doc(admin, 'requests/a'), {userId: 'bob'}));
});
