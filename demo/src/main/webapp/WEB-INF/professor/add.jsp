<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <label>교수번호 : <input v-model="profNo"></label>
            <button @click="fnCheck">중복체크</button>
        </div>
        <div>
            <label>이름 : <input v-model="name"></label>
        </div>
        <div>
            <label>직급 : <input v-model="position"></label>
        </div>
        <div>
            <label>급여 : <input v-model="pay"></label>
        </div>
        <div>학과 : 
            <select v-model="deptNo">
                <option v-for="item in deptList" :value="item.deptNo">{{item.dName}}</option>
            </select>
        </div>
        <div>
            <button @click="fnAdd">추가!</button>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                profNo : "",
                name : "",
                position : "",
                pay : "",
                deptNo : "",

                deptList : []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAdd : function () {
                let self = this;
                if(self.profNo.length != 4){
                    alert("교수번호는 4자리 숫자!");
                    return;
                }

                let param = {
                    profNo : self.profNo,
                    name : self.name,
                    position : self.position,
                    pay : self.pay,
                    deptNo : self.deptNo
                };
                $.ajax({
                    url: "http://localhost:8080/professor/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("추가되었다!");
                        location.href="list.do";
                    }
                });
            },
            fnCheck : function(){
                let self = this;
                let param = {
                    profNo : self.profNo
                };
                $.ajax({
                    url: "http://localhost:8080/professor/info.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        if(data.info == null || data.info == undefined){
                            alert("사용 가능!");
                        } else {
                            alert("이미 사용중인 교수번호");
                        }
                    }
                });
            },
            fnDeptList : function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "http://localhost:8080/professor/dept-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.deptList = data.deptList;
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnDeptList();
        }
    });

    app.mount('#app');
</script>