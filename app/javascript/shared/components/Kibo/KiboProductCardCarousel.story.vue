<script setup>
import ChatCard from '../ChatCard.vue';

const items = [
            {
                "media_url": "https://assets.ajio.com/medias/sys_master/root/hdb/h9a/13582024212510/-1117Wx1400H-460345219-white-MODEL.jpg",
                "title": "Nike Shoes 2.0",
                "description": "Running with Nike Shoe 2.0",
                "actions": [
                    {
                        "type": "link",
                        "text": "View More",
                        "uri": "https://www.google.com"
                    }
                ]
            },
            {
                "media_url": "https://assets.ajio.com/medias/sys_master/root/hdb/h9a/13582024212510/-1117Wx1400H-460345219-white-MODEL.jpg",
                "title": "Nike Shoes 2.1",
                "description": "Running with Nike Shoe 2.0",
                "actions": [
                    {
                        "type": "link",
                        "text": "View More",
                        "uri": "https://www.google.com"
                    }
                ]
            },
            {
                "media_url": "https://assets.ajio.com/medias/sys_master/root/hdb/h9a/13582024212510/-1117Wx1400H-460345219-white-MODEL.jpg",
                "title": "Nike Shoes 2.2",
                "description": "Running with Nike Shoe 2.0",
                "actions": [
                    {
                        "type": "link",
                        "text": "View More",
                        "uri": "https://www.google.com"
                    }
                ]
            }
]

const handleCardClick = (action) => {
    console.log('Card Clicked:', {...action});
};

</script>

<template>
    <Story
      title="Kibo/ProductCardCarousel"
      :layout="{ type: 'grid', width: '500px', height: '600px' }"
    >
        <div class="container">
            <ChatCard
                v-for="item in items"
                :key="item.title"
                :media-url="item.media_url"
                :title="item.title"
                :description="item.description"
                :actions="item.actions"
                 @cardClick="handleCardClick"
            />
        </div>
    </Story>
</template>

<style scoped lang="scss">
@import 'widget/assets/scss/variables.scss';
@import 'dashboard/assets/scss/mixins.scss';

    .container {
        display: flex;
        padding: 1rem;
        gap: 20px;
        overflow-x: auto;
        max-width: 500px;
    }
</style>