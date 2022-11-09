import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id}, {
    connected() {
        console.log('Answers channel connected.');
        this.perform('follow');
    },

    received(data) {
        $('.answers').append(data);
    }
});
