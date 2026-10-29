package com.enterpriseops.dto;

public class ReportDTO {

    private long totalEmployees;
    private long activeEmployees;

    private long totalDepartments;

    private long totalProjects;
    private long activeProjects;

    private long totalTasks;
    private long todoTasks;
    private long inProgressTasks;
    private long completedTasks;
    private long blockedTasks;

    private long totalLeaveRequests;
    private long pendingLeaves;
    private long approvedLeaves;
    private long rejectedLeaves;

    private long totalAttendance;
    private long presentAttendance;
    private long absentAttendance;
    private long lateAttendance;

    public ReportDTO() {
    }

    public long getTotalEmployees() {
        return totalEmployees;
    }

    public void setTotalEmployees(long totalEmployees) {
        this.totalEmployees = totalEmployees;
    }

    public long getActiveEmployees() {
        return activeEmployees;
    }

    public void setActiveEmployees(long activeEmployees) {
        this.activeEmployees = activeEmployees;
    }

    public long getTotalDepartments() {
        return totalDepartments;
    }

    public void setTotalDepartments(long totalDepartments) {
        this.totalDepartments = totalDepartments;
    }

    public long getTotalProjects() {
        return totalProjects;
    }

    public void setTotalProjects(long totalProjects) {
        this.totalProjects = totalProjects;
    }

    public long getActiveProjects() {
        return activeProjects;
    }

    public void setActiveProjects(long activeProjects) {
        this.activeProjects = activeProjects;
    }

    public long getTotalTasks() {
        return totalTasks;
    }

    public void setTotalTasks(long totalTasks) {
        this.totalTasks = totalTasks;
    }

    public long getTodoTasks() {
        return todoTasks;
    }

    public void setTodoTasks(long todoTasks) {
        this.todoTasks = todoTasks;
    }

    public long getInProgressTasks() {
        return inProgressTasks;
    }

    public void setInProgressTasks(long inProgressTasks) {
        this.inProgressTasks = inProgressTasks;
    }

    public long getCompletedTasks() {
        return completedTasks;
    }

    public void setCompletedTasks(long completedTasks) {
        this.completedTasks = completedTasks;
    }

    public long getBlockedTasks() {
        return blockedTasks;
    }

    public void setBlockedTasks(long blockedTasks) {
        this.blockedTasks = blockedTasks;
    }

    public long getTotalLeaveRequests() {
        return totalLeaveRequests;
    }

    public void setTotalLeaveRequests(long totalLeaveRequests) {
        this.totalLeaveRequests = totalLeaveRequests;
    }

    public long getPendingLeaves() {
        return pendingLeaves;
    }

    public void setPendingLeaves(long pendingLeaves) {
        this.pendingLeaves = pendingLeaves;
    }

    public long getApprovedLeaves() {
        return approvedLeaves;
    }

    public void setApprovedLeaves(long approvedLeaves) {
        this.approvedLeaves = approvedLeaves;
    }

    public long getRejectedLeaves() {
        return rejectedLeaves;
    }

    public void setRejectedLeaves(long rejectedLeaves) {
        this.rejectedLeaves = rejectedLeaves;
    }

    public long getTotalAttendance() {
        return totalAttendance;
    }

    public void setTotalAttendance(long totalAttendance) {
        this.totalAttendance = totalAttendance;
    }

    public long getPresentAttendance() {
        return presentAttendance;
    }

    public void setPresentAttendance(long presentAttendance) {
        this.presentAttendance = presentAttendance;
    }

    public long getAbsentAttendance() {
        return absentAttendance;
    }

    public void setAbsentAttendance(long absentAttendance) {
        this.absentAttendance = absentAttendance;
    }

    public long getLateAttendance() {
        return lateAttendance;
    }

    public void setLateAttendance(long lateAttendance) {
        this.lateAttendance = lateAttendance;
    }
}