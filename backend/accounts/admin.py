from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .forms import CustomUserCreationForm, CustomUserChangeForm
from .models import CustomUser, Application

class CustomUserAdmin(UserAdmin):
    add_form = CustomUserCreationForm
    form = CustomUserChangeForm
    model = CustomUser
    readonly_fields = ('pk',)
    list_display = ['username', 'email','properties']
    fieldsets = (
            (None, {'fields': ('properties',)}),
    ) + UserAdmin.fieldsets 

@admin.register(Application)
class ApplicationAdmin(admin.ModelAdmin):
	readonly_fields = ('pk',)
	list_display = ['name']

admin.site.register(CustomUser, CustomUserAdmin)