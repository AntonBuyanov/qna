import consumer from "./consumer"

consumer.subscriptions.create({channel: "QuestionsChannel"}, {
    connected() {
        console.log('Questions channel connected.');
        this.perform('follow');
    },

    received(data) {
        $('.questions').append(data);
    }
});
