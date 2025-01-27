<script setup>
import { ref } from "vue";
import { statuses } from "../const/statuses";

let items = ref(JSON.parse(localStorage.getItem("items")) || []);
let inputContent = ref()
let inputLimit = ref()
let inputState = ref()
let isErrMsg = ref(false)
let isShowModal = ref(false)
let deleteItemId = ''
let deleteItemContent = ref();
let errMsg = ref('')
const today = new Date();

function onEdit(id) {
  let isOnEditOther = false
  items.value.map((item) => {
    if (item.onEdit) {
      isOnEditOther = true;
      return;
    }
  })
  if (isOnEditOther) {
    errMsg.value = "他に編集中のタスクがあります"
    isErrMsg.value = true;
    return
  }
  inputContent.value = items.value[id].content;
  inputLimit.value = items.value[id].limit;
  inputState.value = items.value[id].state;

  if (items.value[id].onEdit == true) {
    items.value[id].onEdit = false;
  } else {
    items.value[id].onEdit = true;
  }
}

function onUpdate(id) {
  const newItem = {
    id: id,
    content: inputContent.value,
    limit: inputLimit.value,
    state: inputState.value,
    onEdit: false
  }

  if (inputContent.value == "" || inputLimit.value == "") {
    errMsg = "タスク・期限を両方入力してください。"
    isErrMsg.value = true
    return
  }
  items.value.splice(id, 1, newItem);
  localStorage.setItem("items", JSON.stringify(items.value));
  isErrMsg.value = false;
}

function showModal(id) {
  isShowModal.value = true;
  deleteItemId = id;
  deleteItemContent = items.value[id].content
}

function onDeleteItem() {
  items.value.splice(deleteItemId, 1)
  isShowModal.value = false
  items.value = items.value.map((item, index) => ({
    id: index,
    content: item.content,
    limit: item.limit,
    state: item.state,
    onEdit: item.onEdit
  }))
  localStorage.setItem("items", JSON.stringify(items.value));
}
function onHideModal() {
  isShowModal.value = false
}
</script>

<template>
  <div>
    <p v-if="isErrMsg">{{ errMsg }}</p>
    <div v-if="isShowModal" class="modal">
      <div class="modal-content">
        <p>{{ deleteItemContent }}削除してもよろしいですか？</p>
        <button @click="onDeleteItem">はい</button>
        <button @click="onHideModal">キャンセル</button>
      </div>
    </div>
    <table>
      <thead>
        <tr>
          <th class="th-id">ID</th>
          <th class="th-value">やること</th>
          <th class="th-limit">期限</th>
          <th class="th-state">状態</th>
          <th class="th-edit">編集</th>
          <th class="th-delete">削除</th>
        </tr>
      </thead>

      <tbody>
        <tr v-for="item in items" :key="item.id" :class="{ red: new Date(item.limit) < today }">
          <td>{{ item.id }}</td>
          <td>
            <span v-if="!item.onEdit">{{ item.content }}</span>
            <input v-else v-model="inputContent" type="text">
          </td>
          <td>
            <span v-if="!item.onEdit">{{ item.limit }}</span>
            <input v-else v-model="inputLimit" type="date">
          </td>
          <td>
            <span v-if="!item.onEdit">{{ item.state.value }}</span>
            <select v-else v-model="inputState">
              <option v-for="state in statuses" :key="state.id" :value="state" :selected="state.id == item.state.id">
                {{ state.value }}
              </option>
            </select>
          </td>
          <td>
            <button v-if="!item.onEdit" @click="onEdit(item.id)">編集</button>
            <button v-else @click="onUpdate(item.id)">完了</button>
          </td>
          <td><button @click="showModal(item.id)">削除</button></td>
        </tr>
      </tbody>

    </table>


  </div>
</template>

<style scoped>
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;

  .modal-content {
    background: #fff;
    padding: 20px;
    border-radius: 8px;
  }

  .red {
    color: red;
  }
}
</style>
