<template>
  <div class="min-h-screen py-8">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center mb-8">
        <h1 class="text-4xl font-semibold text-gray-900 tracking-tight">Рейтинг</h1>
        <button
          v-if="authStore.user?.role === 'admin'"
          @click="resetPoints"
          :disabled="resetting"
          class="glass-btn bg-red-500/80 text-white border-red-400/40"
        >
          {{ resetting ? 'Қалпына келтіруде...' : 'Ұпайларды қалпына келтіру (Айлық)' }}
        </button>
      </div>

      <div v-if="loading" class="text-center py-16">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
        <p class="mt-4 text-gray-600">Жүктелуде...</p>
      </div>

      <div v-else-if="leaderboard.length === 0" class="glass-card p-12 text-center">
        <p class="text-gray-700">Рейтинг деректері жоқ</p>
      </div>

      <div v-else class="space-y-4">
        <div
          v-for="(entry, index) in leaderboard"
          :key="entry.id"
          :class="[
            'glass-card p-6 flex items-center gap-6 transition-glass',
            getRankColor(index)
          ]"
        >
          <!-- Rank Badge -->
          <div class="flex-shrink-0 w-16 h-16 rounded-full flex items-center justify-center font-bold text-xl"
               :class="getRankBadgeColor(index)">
            {{ entry.rank }}
          </div>

          <!-- User Photo -->
          <div class="flex-shrink-0 w-16 h-16 rounded-full overflow-hidden bg-gradient-to-br from-blue-100/50 to-purple-100/50">
            <img
              v-if="entry.photo_url"
              :src="entry.photo_url"
              :alt="entry.full_name"
              class="w-full h-full object-cover"
            />
            <div v-else class="w-full h-full flex items-center justify-center">
              <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
            </div>
          </div>

          <!-- User Info -->
          <div class="flex-1 min-w-0">
            <h3 class="text-xl font-semibold text-gray-900 truncate">{{ entry.full_name }}</h3>
            <p class="text-sm text-gray-600" v-if="entry.group">Топ: {{ entry.group }}</p>
          </div>

          <!-- Points -->
          <div class="flex-shrink-0 text-right">
            <div class="text-3xl font-bold" :class="getRankTextColor(index)">
              {{ entry.points }}
            </div>
            <div class="text-sm text-gray-600">ұпай</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import api from '../services/api'

export default {
  name: 'Leaderboard',
  setup() {
    const authStore = useAuthStore()
    const leaderboard = ref([])
    const loading = ref(true)
    const resetting = ref(false)

    const fetchLeaderboard = async () => {
      try {
        loading.value = true
        const response = await api.get('/leaderboard')
        leaderboard.value = response.data
      } catch (error) {
        console.error('Failed to fetch leaderboard:', error)
      } finally {
        loading.value = false
      }
    }

    const resetPoints = async () => {
      if (!confirm('Are you sure you want to reset all points? This action cannot be undone.')) {
        return
      }

      try {
        resetting.value = true
        await api.post('/leaderboard/reset')
        alert('Points have been reset successfully!')
        await fetchLeaderboard()
      } catch (error) {
        console.error('Failed to reset points:', error)
        alert(error.response?.data?.detail || 'Failed to reset points')
      } finally {
        resetting.value = false
      }
    }

    const getRankColor = (index) => {
      if (index === 0) return 'bg-gradient-to-r from-yellow-50/50 to-yellow-100/50 border-2 border-yellow-400/60'
      if (index === 1) return 'bg-gradient-to-r from-gray-50/50 to-gray-100/50 border-2 border-gray-400/60'
      if (index === 2) return 'bg-gradient-to-r from-orange-50/50 to-orange-100/50 border-2 border-orange-400/60'
      return ''
    }

    const getRankBadgeColor = (index) => {
      if (index === 0) return 'bg-gradient-to-br from-yellow-400 to-yellow-600 text-white'
      if (index === 1) return 'bg-gradient-to-br from-gray-300 to-gray-500 text-white'
      if (index === 2) return 'bg-gradient-to-br from-orange-400 to-orange-600 text-white'
      return 'bg-gradient-to-br from-blue-100 to-blue-200 text-gray-700'
    }

    const getRankTextColor = (index) => {
      if (index === 0) return 'text-yellow-600'
      if (index === 1) return 'text-gray-600'
      if (index === 2) return 'text-orange-600'
      return 'text-gray-900'
    }

    onMounted(() => {
      fetchLeaderboard()
    })

    return {
      authStore,
      leaderboard,
      loading,
      resetting,
      resetPoints,
      getRankColor,
      getRankBadgeColor,
      getRankTextColor
    }
  }
}
</script>

<style scoped>
.transition-glass {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
</style>
