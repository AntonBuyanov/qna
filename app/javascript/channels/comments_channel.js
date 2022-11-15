import consumer from "./consumer"

consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id}, {
    connected() {
        this.perform('follow');
    },

    received(data) {
        let type = data.resource_type;
        let id = data.resource_id;

        if (type === 'Question') {
            $(`#question-comment-${id}`).append(data.partial);
        } else {
            $(`#answer-comment-${id}`).append(data.partial);
        }
    }
});
