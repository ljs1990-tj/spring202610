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
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        #app {
            width : 800px;
            margin : 30px auto;
            margin-bottom: 300px;
        }

        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
            width: 20%;
        }
        td {
            text-align: left;
        }
        td select {
            width: 100px;
            height: 30px;
        }
        td input {
            width: 90%;
            height: 30px;
        }
        .contents{
            width: 750px;
        }
        table {
            width : 100%;
        }
        .editor-area {
            height: 400px;
            padding : 10px 10px 50px 10px;
        }
        .btn-area {
            text-align: center;
            margin-top: 15px;
        }
        .btn-area button{
            height: 30px;
            width: 100px;
            margin: 5px;
            background-color: rgb(186, 236, 237);
            border: 1px solid rgb(106, 187, 188);
            box-shadow: 2px 2px 2px  black;
            cursor: pointer;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="contents">
            <table>
                <tr>
                    <th>카테고리</th>
                    <td>
                        <select v-model="category">
                            
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>제품명</th>
                    <td>
                        <input v-model="productName" class="title">
                    </td>
                </tr>
                <tr>
                    <th>첨부파일</th>
                    <td>
                        <input type="file" id="file1" name="file1" accept=".jpg, .png">
                    </td>
                </tr>
                <tr>
                    <th>제품설명</th>
                    <td class="editor-area">
                        <div id="editor"></div>
                    </td>
                </tr>
            </table>
            <div class="btn-area">
                <button @click="fnAdd">등록</button>
                <button>되돌아가기</button>
            </div>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                category : "",
                productName : "",
                description : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnAdd : function () {
                let self = this;
                let param = {
                    
                };
                $.ajax({
                    url: "http://localhost:8080/board/add.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if($("#file1")[0].files[0] != undefined){
                            self.fnFileAdd(data.boardNo);
                        } else {
                            alert(data.message);
                            location.href="list.do";
                        }
                    }
                });
            },
            fnFileAdd : function(boardNo){
                var self = this;
                console.log($("#file1")[0].files[0]);
                var form = new FormData();
                form.append( "file1",  $("#file1")[0].files[0] );
                form.append( "idx",  boardNo); 
                self.upload(form);  
            }, 
            upload : function(form){
                var self = this;
                console.log(form);
                $.ajax({
                    url : "/board/fileUpload.dox"
                    , type : "POST"
                    , processData : false
                    , contentType : false
                    , data : form
                    , success : function(data) { 
                        alert("등록되었습니다.");
                        location.href="list.do";
                    }	           
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            // Quill 에디터 초기화
            var quill = new Quill('#editor', {
                theme: 'snow',
                modules: {
                    toolbar: [
                        [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                        ['bold', 'italic', 'underline'],
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        ['link', 'image'],
                        [{ 'color': [] }, { 'background': [] }],    
                        ['clean']
                    ]
                }
            });

            // 에디터 내용이 변경될 때마다 Vue 데이터를 업데이트
            quill.on('text-change', function() {
                self.description = quill.root.innerHTML;
            });
        }
    });

    app.mount('#app');
</script>