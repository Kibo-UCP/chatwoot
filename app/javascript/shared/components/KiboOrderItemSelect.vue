<script setup>
import { ref, computed, onMounted } from 'vue';

// Props
const props = defineProps({
  buttonLabel: {
    type: String,
    default: '',
  },
  title: {
    type: String,
  },
  items: {
    type: Array,
    default: () => [],
  },
  orderItems: {
    type: String,
  },
  submittedValues: {
    type: Array,
    default: () => [],
  },
});
// Emits
const emit = defineEmits(['submit']);
const hasSubmitted = ref(false);
// State
const selectedItemIds = ref([]);
const formValues = ref({});

// Computed
const parsedItems = computed(() => {
  try {
    return JSON.parse(props.orderItems)?.toolCall?.inputParameters?.items || [];
  } catch (error) {
    return [];
  }
});

const selectedItems = computed(() => {
  return parsedItems.value.filter(item =>
    selectedItemIds.value.includes(item.lineId)
  );
});

// Methods
const isItemSelected = lineId => {
  return selectedItemIds.value.includes(lineId);
};

const toggleItemSelection = (item, index) => {
  if (isItemSelected(item.lineId)) {
    // Remove from selection
    selectedItemIds.value = selectedItemIds.value.filter(
      id => id !== item.lineId
    );
    const propItem = props.items[index];
    formValues.value[propItem.name] = propItem.options.filter(
      option => option.label !== 'Selected'
    )[0].value;
  } else {
    // Add to selection
    selectedItemIds.value.push(item.lineId);
    const propItem = props.items[index];
    formValues.value[propItem.name] = propItem.options.filter(
      option => option.label === 'Selected'
    )[0].value;
  }
};

const onSubmitClick = () => {
  hasSubmitted.value = true;
};

const clearSelection = () => {
  selectedItemIds.value = [];
};

const handleImageError = event => {
  // Replace broken image with placeholder
  event.target.src = 'https://via.placeholder.com/150?text=No+Image';
};

const handleSubmit = () => {
  if (selectedItems.value.length === 0) {
    return;
  }

  emit('submit', formValues.value);
};

const buildFormObject = formObjectArray => {
  return formObjectArray.reduce((acc, obj) => {
    return {
      ...acc,
      [obj.name]:
        obj.value ||
        obj.options.filter(option => option.label !== 'Selected')[0].value,
    };
  }, {});
};

const updateFormValues = () => {
  formValues.value = buildFormObject(props.submittedValues);
};

const setFormDefaults = () => {
  formValues.value = buildFormObject(props.items);
};

onMounted(() => {
  if (props.submittedValues.length) {
    updateFormValues();
  } else {
    setFormDefaults();
  }
});
</script>

<template>
  <form class="order-items-container" @submit.prevent="handleSubmit">
    <h2 class="section-title">
      {{ title || $t('COMPONENTS.FORM_BUBBLE.ORDER_ITEMS') }}
    </h2>

    <!-- Items list -->
    <div class="items-list">
      <div
        v-for="(item, index) in parsedItems"
        :key="item.lineId"
        class="item-card"
        :class="{
          'has-submitted': hasSubmitted,
        }"
      >
        <!-- Checkbox -->
        <div class="checkbox-container">
          <input
            :id="`item-${item.lineId}`"
            type="checkbox"
            :checked="isItemSelected(item.lineId)"
            class="checkbox"
            @change="toggleItemSelection(item, index)"
          />
        </div>

        <!-- Product image -->
        <div class="image-container">
          <img
            :src="item.imageUrl"
            :alt="item.name"
            class="product-image"
            @error="handleImageError"
          />
        </div>

        <!-- Product details -->
        <div class="product-details">
          <div class="product-name">{{ item.name }}</div>
          <div class="product-meta">
            {{ $t('COMPONENTS.FORM_BUBBLE.ORDER_NO') }}{{ item.orderNumber }}
          </div>
          <div class="product-meta">
            {{ $t('COMPONENTS.FORM_BUBBLE.QUANTITY') }} {{ item.quantity }}
          </div>
        </div>
      </div>

      <!-- Empty state -->
      <div v-if="items.length === 0" class="empty-state">
        {{ $t('COMPONENTS.FORM_BUBBLE.NO_ITEMS_AVAILABLE') }}
      </div>
    </div>

    <!-- Selection summary -->
    <div v-if="selectedItems.length > 0" class="selection-summary">
      <p class="summary-text">
        {{
          $t('COMPONENTS.FORM_BUBBLE.SELECTED_ITEM_COUNT', {
            count: selectedItems.length,
          })
        }}
      </p>
      <button type="button" class="clear-button" @click="clearSelection">
        {{ $t('COMPONENTS.FORM_BUBBLE.CLEAR_SELECTION') }}
      </button>
    </div>

    <!-- Form actions -->
    <div class="form-actions">
      <button
        type="submit"
        class="submit-button button block"
        :disabled="selectedItems.length === 0"
        @click="onSubmitClick"
      >
        {{ buttonLabel || $t('COMPONENTS.FORM_BUBBLE.SUBMIT') }}
      </button>
    </div>
  </form>
</template>

<style scoped>
/* Container styling */
.order-items-container {
  max-width: 800px;
  margin: 0 auto;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen,
    Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
}

/* Section title */
.section-title {
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 1rem;
}

/* Items list */
.items-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* Item card */
.item-card {
  display: flex;
  align-items: center;
  padding: 1rem;
  border: 1px solid #e5e7eb;
  border-radius: 0.5rem;
  transition: background-color 0.2s ease;
}

.item-card:hover {
  background-color: #f9fafb;
}

/* Checkbox styling */
.checkbox-container {
  margin-right: 1rem;
}

.checkbox {
  height: 1.25rem;
  width: 1.25rem;
  border-radius: 0.25rem;
  border: 1px solid #d1d5db;
  cursor: pointer;
}

.checkbox:focus {
  outline: 2px solid #4f46e5;
  outline-offset: 2px;
}

/* Product image */
.image-container {
  height: 4rem;
  width: 4rem;
  flex-shrink: 0;
  overflow: hidden;
  border-radius: 0.375rem;
  border: 1px solid #e5e7eb;
}

.product-image {
  height: 100%;
  width: 100%;
  object-fit: cover;
  object-position: center;
}

/* Product details */
.product-details {
  margin-left: 1rem;
  flex: 1;
}

.product-name {
  font-weight: 500;
  color: #111827;
}

.product-meta {
  margin-top: 0.25rem;
  font-size: 0.875rem;
  color: #6b7280;
}

/* Empty state */
.empty-state {
  text-align: center;
  padding: 2rem 0;
  color: #6b7280;
}

/* Selection summary */
.selection-summary {
  margin-top: 1rem;
  padding: 1rem;
  border-radius: 0.5rem;
}

.summary-text {
  font-size: 0.875rem;
  font-weight: 500;
}

.clear-button {
  margin-top: 0.5rem;
  font-size: 0.875rem;
  color: #4f46e5;
  background: none;
  border: none;
  padding: 0;
  cursor: pointer;
  text-decoration: none;
}

.clear-button:hover {
  color: #4338ca;
}

/* Form actions */
.form-actions {
  margin-top: 1.5rem;
  display: flex;
  justify-content: flex-end;
}

.submit-button {
  background-color: #4f46e5;
  color: white;
  font-weight: 500;
  padding: 0.625rem 1.25rem;
  border-radius: 0.375rem;
  border: none;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.submit-button:hover {
  background-color: #4338ca;
}

.submit-button:focus {
  outline: 2px solid #4f46e5;
  outline-offset: 2px;
}

.submit-button:disabled {
  background-color: #9ca3af;
  cursor: not-allowed;
}

/* Responsive adjustments */
@media (max-width: 640px) {
  .item-card {
    flex-direction: row;
    align-items: center;
  }

  .image-container {
    height: 3rem;
    width: 3rem;
  }

  .product-details {
    margin-left: 0.75rem;
  }

  .form-actions {
    justify-content: center;
  }
}
</style>
