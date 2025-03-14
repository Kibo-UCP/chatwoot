<script setup>
import { ref } from 'vue';
import OrderItemSelect from '../Kibo/KiboOrderItemSelect.vue';

// Sample order items
const orderItems = ref(
  '{"toolCall":{"tool":"<tool-resource-name>","action":"Render Order Item Select","inputParameters":{"items":[{"shipmentNumber":"123","lineId":"1","name":"item1","quantity":"1","orderNumber":"123","imageUrl":"https://images.pexels.com/photos/335257/pexels-photo-335257.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"},{"shipmentNumber":"123","lineId":"2","name":"item2","quantity":"1","orderNumber":"123","imageUrl":"https://images.pexels.com/photos/258244/pexels-photo-258244.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"}]}}}'
);
const items = ref([
  {
    name: 'select-1',
    label: 'Line Item 1 Select',
    type: 'select',
    options: [
      {
        label: 'Not Selected',
        value: 'not-selected-1',
      },
      {
        label: 'Selected',
        value: 'selected-1',
      },
    ],
  },
  {
    name: 'select-2',
    label: 'Line Item 2 Select',
    type: 'select',
    options: [
      {
        label: 'Not Selected',
        value: 'not-selected-2',
      },
      {
        label: 'Selected',
        value: 'selected-2',
      },
    ],
  },
]);

const handleSubmit = () => {
  console.log('Selection changed:');
};
</script>

<template>
  <Story
    title="Kibo/OrderItemSelect"
    :layout="{ type: 'grid', width: '500px', height: '600px' }"
  >
    <OrderItemSelect
      :items="items"
      :order-items="orderItems"
      @submit="handleSubmit"
    />
  </Story>
</template>
